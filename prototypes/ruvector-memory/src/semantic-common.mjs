import { execFileSync } from 'node:child_process';
import crypto from 'node:crypto';
import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';

const HOME = process.env.HOME || '/home/lch';

export const APPROVED_DOCS_DIR = path.join(HOME, '.local/share/bazzite-security/gemma-knowledge/docs');
export const STAGE3A_CHUNKS_FILE = path.join(HOME, '.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl');
export const EVAL_CASES_DIR = path.join(HOME, '.local/share/bazzite-security/gemma-evals/cases');
export const SEMANTIC_OUTPUT_DIR = path.join(HOME, '.local/share/bazzite-security/ruvector/semantic-prototype');
export const SEMANTIC_CACHE_DIR = path.join(SEMANTIC_OUTPUT_DIR, 'cache');
export const SEMANTIC_INDEX_PATH = path.join(SEMANTIC_OUTPUT_DIR, 'semantic-approved-docs-memory.json');
export const SEMANTIC_CACHE_PATH = path.join(SEMANTIC_CACHE_DIR, 'embeddings.json');
export const REPORTS_DIR = path.resolve(new URL('../reports', import.meta.url).pathname);
export const OFFLOAD_REPORTS_DIR = path.join(HOME, 'offload/security-reports/manual');

export const EMBEDDING_MODEL = 'nomic-embed-text';
export const EMBEDDING_MODEL_TAG = 'nomic-embed-text:latest';
export const EMBEDDING_DIMENSIONS = 768;
export const OLLAMA_HOSTNAME = '127.0.0.1';
export const OLLAMA_PORT = 11434;

export const TEST_QUERIES = [
  'What is the safe operating model for local Gemma?',
  'Where should generated security reports go?',
  'Which package manager should be used on Bazzite?',
  'What should Gemma do if evidence is missing?',
  'What firewall tool does Bazzite use?',
  'Where should Gemma wrapper scripts be installed?',
  'Where should security logs be written?',
  'Where should the knowledge pack index be stored?'
];

export function ensureDirectory(directory) {
  fs.mkdirSync(directory, { recursive: true });
}

export function stableHash(value) {
  return crypto.createHash('sha256').update(value).digest('hex');
}

export function chunkText(text) {
  const paragraphs = text.split(/\n\n+/).filter((paragraph) => paragraph.trim().length > 20);
  return paragraphs.map((chunk, idx) => {
    const textValue = chunk.trim();
    return {
      id: `chunk_${idx}`,
      text: textValue,
      hash: stableHash(textValue).substring(0, 16)
    };
  });
}

export function collectApprovedChunks(limit = Number.POSITIVE_INFINITY) {
  if (!fs.existsSync(APPROVED_DOCS_DIR)) {
    throw new Error(`Approved docs directory not found: ${APPROVED_DOCS_DIR}`);
  }

  const chunks = [];
  const files = fs.readdirSync(APPROVED_DOCS_DIR).filter((file) => file.endsWith('.md')).sort();

  for (const filename of files) {
    const filepath = path.join(APPROVED_DOCS_DIR, filename);
    const content = fs.readFileSync(filepath, 'utf-8');
    for (const chunk of chunkText(content)) {
      chunks.push({
        id: `${filename}:${chunk.id}`,
        filename,
        filepath,
        sourceType: 'approved-doc',
        text: chunk.text,
        hash: chunk.hash
      });
      if (chunks.length >= limit) return chunks;
    }
  }

  if (fs.existsSync(STAGE3A_CHUNKS_FILE)) {
    const lines = fs.readFileSync(STAGE3A_CHUNKS_FILE, 'utf-8').trim().split('\n').slice(0, 50);
    lines.forEach((line, idx) => {
      if (chunks.length >= limit) return;
      try {
        const parsed = JSON.parse(line);
        const text = String(parsed.chunk || parsed.text || '').trim();
        if (text.length === 0) return;
        chunks.push({
          id: `stage3a_${idx}`,
          filename: 'chunks.jsonl (Stage 3A)',
          filepath: STAGE3A_CHUNKS_FILE,
          sourceType: 'stage3a-chunk',
          text,
          hash: stableHash(text).substring(0, 16)
        });
      } catch {
        // Skip malformed lines in the Stage 3A chunk file.
      }
    });
  }

  return chunks;
}

export function loadCache() {
  if (!fs.existsSync(SEMANTIC_CACHE_PATH)) return {};
  return JSON.parse(fs.readFileSync(SEMANTIC_CACHE_PATH, 'utf-8'));
}

export function saveCache(cache) {
  ensureDirectory(SEMANTIC_CACHE_DIR);
  fs.writeFileSync(SEMANTIC_CACHE_PATH, JSON.stringify(cache, null, 2));
}

export function requestEmbedding(prompt) {
  const payload = JSON.stringify({ model: EMBEDDING_MODEL, prompt });

  return new Promise((resolve, reject) => {
    const request = http.request({
      hostname: OLLAMA_HOSTNAME,
      port: OLLAMA_PORT,
      path: '/api/embeddings',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(payload)
      },
      timeout: 30000
    }, (response) => {
      let body = '';
      response.on('data', (chunk) => {
        body += chunk;
      });
      response.on('end', () => {
        if (response.statusCode !== 200) {
          reject(new Error(`Ollama embeddings returned HTTP ${response.statusCode}: ${body.substring(0, 200)}`));
          return;
        }
        try {
          const parsed = JSON.parse(body);
          if (!Array.isArray(parsed.embedding)) {
            reject(new Error('Ollama embeddings response did not include an embedding array'));
            return;
          }
          resolve(parsed.embedding);
        } catch (error) {
          reject(error);
        }
      });
    });

    request.on('timeout', () => {
      request.destroy(new Error('Ollama embeddings request timed out'));
    });
    request.on('error', reject);
    request.write(payload);
    request.end();
  });
}

export async function embedWithCache(text, cache) {
  const key = `${EMBEDDING_MODEL_TAG}:${stableHash(text)}`;
  if (cache[key]?.embedding) {
    return { embedding: cache[key].embedding, fromCache: true };
  }

  const embedding = await requestEmbedding(text);
  if (embedding.length !== EMBEDDING_DIMENSIONS) {
    throw new Error(`Expected ${EMBEDDING_DIMENSIONS} dimensions, got ${embedding.length}`);
  }
  cache[key] = {
    model: EMBEDDING_MODEL_TAG,
    dimensions: embedding.length,
    createdAt: new Date().toISOString(),
    embedding
  };
  return { embedding, fromCache: false };
}

export function cosineSimilarity(vecA, vecB) {
  if (vecA.length !== vecB.length) return 0;
  let dotProduct = 0;
  let normA = 0;
  let normB = 0;
  for (let i = 0; i < vecA.length; i++) {
    dotProduct += vecA[i] * vecB[i];
    normA += vecA[i] * vecA[i];
    normB += vecB[i] * vecB[i];
  }
  if (normA === 0 || normB === 0) return 0;
  return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
}

export function loadSemanticIndex() {
  if (!fs.existsSync(SEMANTIC_INDEX_PATH)) {
    throw new Error(`Semantic index not found: ${SEMANTIC_INDEX_PATH}`);
  }
  return JSON.parse(fs.readFileSync(SEMANTIC_INDEX_PATH, 'utf-8'));
}

export async function querySemanticIndex(query, indexData, topK = 5) {
  const cache = loadCache();
  const { embedding } = await embedWithCache(query, cache);
  saveCache(cache);

  return indexData.chunks
    .map((chunk) => ({
      id: chunk.id,
      filename: chunk.filename,
      sourceType: chunk.sourceType,
      text: chunk.text,
      similarity: cosineSimilarity(embedding, chunk.embedding)
    }))
    .sort((a, b) => b.similarity - a.similarity)
    .slice(0, topK);
}

export function runStage3ASearch(query) {
  try {
    return execFileSync('gemma-knowledge-search', [query], {
      encoding: 'utf-8',
      timeout: 30000,
      maxBuffer: 50 * 1024 * 1024
    });
  } catch (error) {
    return `Error running Stage 3A search: ${error.message}`;
  }
}

export function parseStage3AFilenames(output) {
  const filenames = [];
  for (const line of output.split('\n')) {
    const mdMatch = line.match(/([A-Z_]+\.md)/);
    if (mdMatch && !filenames.includes(mdMatch[1])) {
      filenames.push(mdMatch[1]);
    }
  }
  return filenames;
}

export function loadEvaluationQueries() {
  const files = ['knowledge_rag_cases.jsonl', 'path_policy_cases.jsonl'];
  const queries = [];
  for (const filename of files) {
    const filepath = path.join(EVAL_CASES_DIR, filename);
    if (!fs.existsSync(filepath)) continue;
    const lines = fs.readFileSync(filepath, 'utf-8').trim().split('\n');
    for (const line of lines) {
      const parsed = JSON.parse(line);
      queries.push({ id: parsed.id, type: parsed.type, input: parsed.input });
    }
  }
  return queries;
}

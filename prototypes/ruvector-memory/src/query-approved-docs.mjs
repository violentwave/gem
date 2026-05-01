#!/usr/bin/env node
/**
 * RuVector Memory Prototype - Query Approved Docs
 *
 * Queries the indexed approved docs using placeholder vectors.
 * Retrieval only - does not call Gemma/Ollama.
 */

import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Canonical paths
const OUTPUT_DIR = path.join(process.env.HOME || '/home/lch', '.local/share/bazzite-security/ruvector');

// Generate deterministic placeholder vector (must match indexer)
function generatePlaceholderVector(text, dimensions = 384) {
  const hash = crypto.createHash('sha256').update(text).digest();
  const vector = [];
  for (let i = 0; i < dimensions; i++) {
    vector.push((hash[i % hash.length] / 127.5) - 1);
  }
  return vector;
}

// Cosine similarity between vectors
function cosineSimilarity(vecA, vecB) {
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

// Find top similar chunks
function findSimilarChunks(query, indexData, topK = 5) {
  const queryVector = generatePlaceholderVector(query);

  const results = [];

  for (const doc of indexData.documents) {
    for (const chunk of doc.chunks) {
      const similarity = cosineSimilarity(queryVector, chunk.vector);
      results.push({
        filename: doc.filename,
        chunkId: chunk.id,
        text: chunk.text,
        hash: chunk.hash,
        similarity: similarity,
        isStage3A: doc.isStage3A || false
      });
    }
  }

  // Sort by similarity and return top K
  return results
    .sort((a, b) => b.similarity - a.similarity)
    .slice(0, topK);
}

// Main query function
async function queryDocs(query) {
  console.log('=== RuVector Prototype: Query Memory ===\n');
  console.log(`Query: "${query}"\n`);

  // Load index
  const indexPath = path.join(OUTPUT_DIR, 'approved-docs-memory.json');

  if (!fs.existsSync(indexPath)) {
    console.error('ERROR: Index not found. Run indexing first:');
    console.error('  npm run index');
    process.exit(1);
  }

  const indexData = JSON.parse(fs.readFileSync(indexPath, 'utf-8'));
  console.log(`Loaded index: ${indexData.documentCount} documents, ${indexData.chunkCount} chunks`);
  console.log(`Vector type: ${indexData.vectorType}\n`);

  // Search
  const results = findSimilarChunks(query, indexData);

  console.log('=== Top Results ===\n');

  results.forEach((result, idx) => {
    console.log(`--- Result ${idx + 1} (similarity: ${result.similarity.toFixed(4)}) ---`);
    console.log(`Source: ${result.filename}${result.isStage3A ? ' [Stage 3A]' : ''}`);
    console.log(`Chunk: ${result.chunkId}`);
    console.log(`Text: ${result.text.substring(0, 150)}...`);
    console.log('');
  });

  console.log(`\nNote: Using placeholder vectors (deterministic hash), not semantic embeddings.`);

  return results;
}

// Get query from command line
const query = process.argv.slice(2).join(' ') || 'What is the safe operating model for local Gemma?';
queryDocs(query).catch(console.error);

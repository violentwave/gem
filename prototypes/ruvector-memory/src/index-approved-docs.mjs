#!/usr/bin/env node
/**
 * RuVector Memory Prototype - Index Approved Docs
 *
 * Uses placeholder vectors (deterministic hash) since no embedding models available.
 * Only indexes approved copied knowledge docs from canonical paths.
 */

import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Canonical paths
const APPROVED_DOCS_DIR = path.join(process.env.HOME || '/home/lch', '.local/share/bazzite-security/gemma-knowledge/docs');
const CHUNKS_FILE = path.join(process.env.HOME || '/home/lch', '.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl');
const OUTPUT_DIR = path.join(process.env.HOME || '/home/lch', '.local/share/bazzite-security/ruvector');

// Generate deterministic placeholder vector using hash
function generatePlaceholderVector(text, dimensions = 384) {
  const hash = crypto.createHash('sha256').update(text).digest();
  const vector = [];
  for (let i = 0; i < dimensions; i++) {
    // Normalize to -1 to 1 range using hash bytes
    vector.push((hash[i % hash.length] / 127.5) - 1);
  }
  return vector;
}

// Simple text chunking by paragraphs
function chunkText(text) {
  const paragraphs = text.split(/\n\n+/).filter(p => p.trim().length > 20);
  return paragraphs.map((chunk, idx) => ({
    id: `chunk_${idx}`,
    text: chunk.trim(),
    // Generate deterministic hash for this chunk
    hash: crypto.createHash('sha256').update(chunk.trim()).digest('hex').substring(0, 16)
  }));
}

// Read and index approved Markdown docs
async function indexApprovedDocs() {
  console.log('=== RuVector Prototype: Index Approved Docs ===\n');
  console.log(`Input directory: ${APPROVED_DOCS_DIR}`);
  console.log(`Output directory: ${OUTPUT_DIR}\n`);

  // Verify approved directory exists
  if (!fs.existsSync(APPROVED_DOCS_DIR)) {
    console.error(`ERROR: Approved docs directory not found: ${APPROVED_DOCS_DIR}`);
    process.exit(1);
  }

  // Get all .md files from approved directory
  const files = fs.readdirSync(APPROVED_DOCS_DIR).filter(f => f.endsWith('.md'));
  console.log(`Found ${files.length} approved Markdown files:\n`);

  const indexData = {
    timestamp: new Date().toISOString(),
    source: 'approved-docs',
    documentCount: 0,
    chunkCount: 0,
    documents: []
  };

  for (const filename of files) {
    const filepath = path.join(APPROVED_DOCS_DIR, filename);
    console.log(`Processing: ${filename}`);

    try {
      const content = fs.readFileSync(filepath, 'utf-8');
      const chunks = chunkText(content);

      const doc = {
        filename,
        filepath,
        chunkCount: chunks.length,
        chunks: chunks.map(chunk => ({
          id: chunk.id,
          text: chunk.text.substring(0, 200) + (chunk.text.length > 200 ? '...' : ''),
          hash: chunk.hash,
          // Generate placeholder vector for each chunk
          vector: generatePlaceholderVector(chunk.text)
        }))
      };

      indexData.documents.push(doc);
      indexData.documentCount++;
      indexData.chunkCount += chunks.length;

      console.log(`  -> ${chunks.length} chunks indexed`);
    } catch (err) {
      console.error(`  -> ERROR reading ${filename}: ${err.message}`);
    }
  }

  // Also try to use Stage 3A chunks if available
  if (fs.existsSync(CHUNKS_FILE)) {
    console.log(`\nAlso processing Stage 3A chunks: ${CHUNKS_FILE}`);
    try {
      const chunksContent = fs.readFileSync(CHUNKS_FILE, 'utf-8');
      const lines = chunksContent.trim().split('\n');
      const stage3aChunks = lines.slice(0, 50).map((line) => {
        try {
          return JSON.parse(line);
        } catch {
          return null;
        }
      }).filter(c => c !== null);

      if (stage3aChunks.length > 0) {
        console.log(`  -> Found ${stage3aChunks.length} Stage 3A chunks (limited to 50)`);
        // Merge Stage 3A chunks
        const stage3aDoc = {
          filename: 'chunks.jsonl (Stage 3A)',
          filepath: CHUNKS_FILE,
          chunkCount: stage3aChunks.length,
          chunks: stage3aChunks.map((chunk, idx) => ({
            id: `stage3a_${idx}`,
            text: (chunk.chunk || chunk.text || '').substring(0, 200),
            hash: crypto.createHash('sha256').update(chunk.chunk || chunk.text || '').digest('hex').substring(0, 16),
            vector: generatePlaceholderVector(chunk.chunk || chunk.text || '')
          })),
          isStage3A: true
        };
        indexData.documents.push(stage3aDoc);
        indexData.chunkCount += stage3aChunks.length;
        console.log(`  -> Added ${stage3aChunks.length} Stage 3A chunks to index`);
      }
    } catch (err) {
      console.error(`  -> ERROR reading chunks.jsonl: ${err.message}`);
    }
  }

  // Write manifest
  const manifest = {
    ...indexData,
    vectorType: 'placeholder-hash',
    dimensions: 384,
    note: 'Using deterministic placeholder vectors - not semantic embeddings'
  };

  const manifestPath = path.join(OUTPUT_DIR, `manifest-${Date.now()}.json`);
  fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
  console.log(`\nManifest written: ${manifestPath}`);

  // Also write latest
  const latestPath = path.join(OUTPUT_DIR, 'approved-docs-memory.json');
  fs.writeFileSync(latestPath, JSON.stringify(manifest, null, 2));
  console.log(`Latest index: ${latestPath}`);

  console.log(`\n=== Indexing Complete ===`);
  console.log(`Total documents: ${indexData.documentCount}`);
  console.log(`Total chunks: ${indexData.chunkCount}`);
  console.log(`Vector type: placeholder (deterministic hash)`);

  return manifest;
}

// Run if executed directly
indexApprovedDocs().catch(console.error);

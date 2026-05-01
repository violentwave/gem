#!/usr/bin/env node
import { loadSemanticIndex, querySemanticIndex } from './semantic-common.mjs';

async function main() {
  const query = process.argv.slice(2).join(' ') || 'What is the safe operating model for local Gemma?';
  const indexData = loadSemanticIndex();
  const results = await querySemanticIndex(query, indexData, 5);

  console.log('=== RuVector Semantic Prototype: Query Memory ===\n');
  console.log(`Query: "${query}"`);
  console.log(`Model: ${indexData.model}`);
  console.log(`Chunks: ${indexData.chunkCount}\n`);

  results.forEach((result, idx) => {
    console.log(`--- Result ${idx + 1} (similarity: ${result.similarity.toFixed(4)}) ---`);
    console.log(`Source: ${result.filename}`);
    console.log(`Type: ${result.sourceType}`);
    console.log(`Chunk: ${result.id}`);
    console.log(`Text: ${result.text.substring(0, 180)}...`);
    console.log('');
  });
}

main().catch((error) => {
  console.error(`ERROR: ${error.message}`);
  process.exit(1);
});

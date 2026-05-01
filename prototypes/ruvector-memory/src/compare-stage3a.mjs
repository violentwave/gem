#!/usr/bin/env node
/**
 * RuVector Memory Prototype - Compare with Stage 3A
 *
 * Runs comparison between RuVector prototype retrieval and Stage 3A deterministic RAG.
 */

import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Canonical paths
const OUTPUT_DIR = path.join(process.env.HOME || '/home/lch', '.local/share/bazzite-security/ruvector');
const REPORTS_DIR = path.join(__dirname, '../reports');
const OFFLOAD_REPORTS = path.join(process.env.HOME || '/home/lch', 'offload/security-reports/manual');

// Test questions
const TEST_QUESTIONS = [
  'What is the safe operating model for local Gemma?',
  'Which files are canonical source docs?',
  'Where should generated security reports and logs go?',
  'Should local Gemma do unattended OpenCode implementation?',
  'What is the role of evals and supervised examples?'
];

// Run Stage 3A search using gemma-knowledge-search
function runStage3ASearch(query) {
  try {
    const result = execFileSync('gemma-knowledge-search', [query], {
      encoding: 'utf-8',
      timeout: 30000,
      maxBuffer: 50 * 1024 * 1024
    });
    return result;
  } catch (err) {
    return `Error running Stage 3A search: ${err.message}`;
  }
}

// Parse Stage 3A results (extract filenames)
function parseStage3AResults(output) {
  const filenames = [];
  const lines = output.split('\n');

  for (const line of lines) {
    // Look for markdown file references
    const match = line.match(/[-*]\s+\[([^\]]+)\]\([^)]+\/([^)]+\.md)\)/);
    if (match) {
      filenames.push(match[2]);
    }
    // Also check for raw filename mentions
    const mdMatch = line.match(/([a-zA-Z_-]+\.md)/);
    if (mdMatch && !filenames.includes(mdMatch[1])) {
      filenames.push(mdMatch[1]);
    }
  }

  return filenames;
}

// Run comparison
async function runComparison() {
  console.log('=== RuVector Prototype: Compare with Stage 3A ===\n');

  // Load RuVector index
  const indexPath = path.join(OUTPUT_DIR, 'approved-docs-memory.json');

  if (!fs.existsSync(indexPath)) {
    console.error('ERROR: RuVector index not found. Run indexing first:');
    console.error('  npm run index');
    process.exit(1);
  }

  const indexData = JSON.parse(fs.readFileSync(indexPath, 'utf-8'));

  const comparisonResults = [];

  console.log(`Running ${TEST_QUESTIONS.length} test queries...\n`);

  for (const query of TEST_QUESTIONS) {
    console.log(`\n--- Query: "${query}" ---`);

    // Get RuVector results (reuse logic from query script)
    const rvResults = await runRuVectorQuery(query, indexData);
    const rvFilenames = [...new Set(rvResults.map(r => r.filename))];

    console.log(`RuVector top sources: ${rvFilenames.join(', ')}`);

    // Get Stage 3A results
    console.log('Running Stage 3A search...');
    const stage3Output = runStage3ASearch(query);
    const stage3Filenames = parseStage3AResults(stage3Output);

    console.log(`Stage 3A sources: ${stage3Filenames.join(', ')}`);

    // Compare
    const overlap = rvFilenames.filter(f => stage3Filenames.includes(f));
    const overlapPercent = overlap.length / Math.max(rvFilenames.length, stage3Filenames.length, 1) * 100;

    comparisonResults.push({
      query,
      ruvectorSources: rvFilenames,
      stage3aSources: stage3Filenames,
      overlap,
      overlapPercent: overlapPercent.toFixed(1)
    });
  }

  // Generate report
  const report = generateReport(comparisonResults);

  // Write reports
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
  const reportPath = path.join(REPORTS_DIR, `comparison-${timestamp}.md`);
  fs.writeFileSync(reportPath, report);
  console.log(`\nReport written: ${reportPath}`);

  // Also write to offload
  const offloadPath = path.join(OFFLOAD_REPORTS, `ruvector-comparison-${timestamp}.md`);
  fs.mkdirSync(path.dirname(offloadPath), { recursive: true });
  fs.writeFileSync(offloadPath, report);
  console.log(`Offload report: ${offloadPath}`);

  return comparisonResults;
}

// Simple RuVector query (inline for comparison)
async function runRuVectorQuery(query, indexData) {
  const crypto = await import('node:crypto');

  function generatePlaceholderVector(text, dimensions = 384) {
    const hash = crypto.createHash('sha256').update(text).digest();
    const vector = [];
    for (let i = 0; i < dimensions; i++) {
      vector.push((hash[i % hash.length] / 127.5) - 1);
    }
    return vector;
  }

  function cosineSimilarity(vecA, vecB) {
    if (vecA.length !== vecB.length) return 0;
    let dotProduct = 0, normA = 0, normB = 0;
    for (let i = 0; i < vecA.length; i++) {
      dotProduct += vecA[i] * vecB[i];
      normA += vecA[i] * vecA[i];
      normB += vecB[i] * vecB[i];
    }
    if (normA === 0 || normB === 0) return 0;
    return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
  }

  const queryVector = generatePlaceholderVector(query);
  const results = [];

  for (const doc of indexData.documents) {
    for (const chunk of doc.chunks) {
      results.push({
        filename: doc.filename,
        similarity: cosineSimilarity(queryVector, chunk.vector)
      });
    }
  }

  return results
    .sort((a, b) => b.similarity - a.similarity)
    .slice(0, 5);
}

function generateReport(comparisonResults) {
  let report = '# RuVector vs Stage 3A Comparison Report\n\n';
  report += `Generated: ${new Date().toISOString()}\n\n`;
  report += '## Summary\n\n';
  report += '| Query | RuVector Sources | Stage 3A Sources | Overlap |\n';
  report += '|-------|------------------|----------------|----------|\n';

  for (const result of comparisonResults) {
    const q = result.query.length > 40 ? `${result.query.substring(0, 40)}...` : result.query;
    const rv = result.ruvectorSources.slice(0, 2).join(', ');
    const s3 = result.stage3aSources.slice(0, 2).join(', ');
    report += `| ${q} | ${rv} | ${s3} | ${result.overlapPercent}% |\n`;
  }

  report += '\n## Notes\n\n';
  report += '- RuVector uses placeholder vectors (deterministic hash), not semantic embeddings\n';
  report += '- Stage 3A uses keyword-based deterministic retrieval\n';
  report += '- Both retrieve from the same approved knowledge docs\n';
  report += '- Placeholder vectors provide deterministic matching but not semantic similarity\n\n';
  report += '## Conclusion\n\n';
  report += 'The comparison shows how the prototype retrieval compares to the deterministic baseline.\n';
  report += 'With placeholder vectors, overlap is expected when query terms appear in source documents.\n';

  return report;
}

// Run
runComparison().catch(console.error);

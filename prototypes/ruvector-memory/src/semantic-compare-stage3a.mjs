#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";

import {
	loadEvaluationQueries,
	loadSemanticIndex,
	OFFLOAD_REPORTS_DIR,
	parseStage3AFilenames,
	querySemanticIndex,
	REPORTS_DIR,
	runStage3ASearch,
} from "./semantic-common.mjs";

function unique(values) {
	return [...new Set(values.filter(Boolean))];
}

async function main() {
	const indexData = loadSemanticIndex();
	const queries = loadEvaluationQueries();
	const results = [];

	console.log("=== RuVector Semantic Prototype: Compare with Stage 3A ===\n");
	console.log(`Semantic chunks: ${indexData.chunkCount}`);
	console.log(`Queries: ${queries.length}\n`);

	for (const query of queries) {
		const semanticResults = await querySemanticIndex(query.input, indexData, 5);
		const semanticSources = unique(
			semanticResults.map((result) => result.filename),
		);
		const stage3AOutput = runStage3ASearch(query.input);
		const stage3ASources = parseStage3AFilenames(stage3AOutput);
		const overlap = semanticSources.filter((source) =>
			stage3ASources.includes(source),
		);
		const overlapPercent =
			(overlap.length /
				Math.max(semanticSources.length, stage3ASources.length, 1)) *
			100;

		results.push({
			id: query.id,
			type: query.type,
			query: query.input,
			semanticSources,
			stage3ASources,
			overlap,
			overlapPercent: Number(overlapPercent.toFixed(1)),
			topSemanticScore: semanticResults[0]?.similarity ?? 0,
		});

		console.log(
			`${query.id}: semantic=${semanticSources.join(", ")} | stage3a=${stage3ASources.join(", ")} | overlap=${overlapPercent.toFixed(1)}%`,
		);
	}

	const overlaps = results.map((result) => result.overlapPercent);
	const minOverlap = overlaps.length > 0 ? Math.min(...overlaps) : 0;
	const maxOverlap = overlaps.length > 0 ? Math.max(...overlaps) : 0;
	const avgOverlap =
		overlaps.length > 0
			? overlaps.reduce((sum, value) => sum + value, 0) / overlaps.length
			: 0;
	const report = generateReport(
		indexData,
		results,
		minOverlap,
		maxOverlap,
		avgOverlap,
	);

	fs.mkdirSync(REPORTS_DIR, { recursive: true });
	fs.mkdirSync(OFFLOAD_REPORTS_DIR, { recursive: true });
	const timestamp = new Date()
		.toISOString()
		.replace(/[:.]/g, "-")
		.substring(0, 19);
	const reportPath = path.join(
		REPORTS_DIR,
		`semantic-comparison-${timestamp}.md`,
	);
	const offloadPath = path.join(
		OFFLOAD_REPORTS_DIR,
		`ruvector-semantic-comparison-${timestamp}.md`,
	);
	fs.writeFileSync(reportPath, report);
	fs.writeFileSync(offloadPath, report);

	console.log(`\nReport written: ${reportPath}`);
	console.log(`Offload report: ${offloadPath}`);
	console.log(
		`Overlap range: ${minOverlap.toFixed(1)}% - ${maxOverlap.toFixed(1)}%`,
	);
	console.log(`Average overlap: ${avgOverlap.toFixed(1)}%`);
}

function generateReport(
	indexData,
	results,
	minOverlap,
	maxOverlap,
	avgOverlap,
) {
	let report = "# RuVector Semantic Prototype vs Stage 3A Report\n\n";
	report += `Generated: ${new Date().toISOString()}\n\n`;
	report += "## Summary\n\n";
	report += `- Model: ${indexData.model}\n`;
	report += `- Dimensions: ${indexData.dimensions}\n`;
	report += `- Semantic chunks: ${indexData.chunkCount}\n`;
	report += `- Evaluation queries: ${results.length}\n`;
	report += `- Source overlap range: ${minOverlap.toFixed(1)}% - ${maxOverlap.toFixed(1)}%\n`;
	report += `- Average source overlap: ${avgOverlap.toFixed(1)}%\n\n`;
	report += "## Results\n\n";
	report +=
		"| ID | Query | Semantic Sources | Stage 3A Sources | Overlap | Top Score |\n";
	report +=
		"|----|-------|------------------|------------------|---------|-----------|\n";
	for (const result of results) {
		const query =
			result.query.length > 42
				? `${result.query.substring(0, 42)}...`
				: result.query;
		report += `| ${result.id} | ${query} | ${result.semanticSources.slice(0, 3).join(", ")} | ${result.stage3ASources.slice(0, 3).join(", ")} | ${result.overlapPercent.toFixed(1)}% | ${result.topSemanticScore.toFixed(4)} |\n`;
	}
	report += "\n## Notes\n\n";
	report +=
		"- Semantic retrieval used the already-installed local Ollama model `nomic-embed-text:latest`.\n";
	report += "- Stage 3A remains the canonical fallback.\n";
	report += "- This is a scoped prototype, not production memory.\n";
	return report;
}

main().catch((error) => {
	console.error(`ERROR: ${error.message}`);
	process.exit(1);
});

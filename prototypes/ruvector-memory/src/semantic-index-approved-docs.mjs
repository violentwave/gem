#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";

import {
	APPROVED_DOCS_DIR,
	collectApprovedChunks,
	EMBEDDING_DIMENSIONS,
	EMBEDDING_MODEL_TAG,
	embedWithCache,
	ensureDirectory,
	loadCache,
	SEMANTIC_INDEX_PATH,
	SEMANTIC_OUTPUT_DIR,
	STAGE3A_CHUNKS_FILE,
	saveCache,
} from "./semantic-common.mjs";

function parseLimit() {
	const limitIndex = process.argv.indexOf("--limit");
	if (limitIndex === -1) return Number.POSITIVE_INFINITY;
	const value = Number.parseInt(process.argv[limitIndex + 1], 10);
	if (!Number.isFinite(value) || value <= 0) {
		throw new Error("--limit must be a positive integer");
	}
	return value;
}

async function main() {
	const limit = parseLimit();
	ensureDirectory(SEMANTIC_OUTPUT_DIR);

	const chunks = collectApprovedChunks(limit);
	const cache = loadCache();
	let cacheHits = 0;
	let cacheMisses = 0;

	console.log("=== RuVector Semantic Prototype: Index Approved Docs ===\n");
	console.log(`Model: ${EMBEDDING_MODEL_TAG}`);
	console.log(`Dimensions: ${EMBEDDING_DIMENSIONS}`);
	console.log(`Approved docs: ${APPROVED_DOCS_DIR}`);
	console.log(`Stage 3A chunks: ${STAGE3A_CHUNKS_FILE}`);
	console.log(
		`Chunk limit: ${Number.isFinite(limit) ? limit : "full approved set"}\n`,
	);

	const embeddedChunks = [];
	for (const [idx, chunk] of chunks.entries()) {
		const { embedding, fromCache } = await embedWithCache(chunk.text, cache);
		if (fromCache) cacheHits++;
		else cacheMisses++;
		embeddedChunks.push({
			...chunk,
			text: chunk.text.substring(0, 500),
			embedding,
		});
		if ((idx + 1) % 25 === 0 || idx + 1 === chunks.length) {
			saveCache(cache);
			console.log(
				`Embedded ${idx + 1}/${chunks.length} chunks (cache hits: ${cacheHits}, misses: ${cacheMisses})`,
			);
		}
	}

	const manifest = {
		timestamp: new Date().toISOString(),
		source: "approved-docs-semantic-prototype",
		package: "ruvector",
		model: EMBEDDING_MODEL_TAG,
		dimensions: EMBEDDING_DIMENSIONS,
		vectorType: "ollama-embedding",
		approvedInputPaths: [APPROVED_DOCS_DIR, STAGE3A_CHUNKS_FILE],
		excludedPaths: [
			"~/projects",
			"~/offload/security-reports",
			"~/.config/**/*.env",
			"browser data",
			"raw logs",
			"private code",
		],
		chunkLimit: Number.isFinite(limit) ? limit : null,
		chunkCount: embeddedChunks.length,
		cacheHits,
		cacheMisses,
		chunks: embeddedChunks,
	};

	fs.writeFileSync(SEMANTIC_INDEX_PATH, JSON.stringify(manifest, null, 2));
	const manifestPath = path.join(
		SEMANTIC_OUTPUT_DIR,
		`semantic-manifest-${Date.now()}.json`,
	);
	fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
	saveCache(cache);

	console.log(`\nSemantic index written: ${SEMANTIC_INDEX_PATH}`);
	console.log(`Semantic manifest written: ${manifestPath}`);
	console.log(`Chunks indexed: ${embeddedChunks.length}`);
}

main().catch((error) => {
	console.error(`ERROR: ${error.message}`);
	process.exit(1);
});

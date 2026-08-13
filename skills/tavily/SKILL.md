---
name: tavily
description: "Trigger: explicit Tavily CLI (tvly) requests or parent research handoff. Tavily CLI execution adapter — choose one capability by need; not generic web research."
license: Apache-2.0
metadata:
  author: "jonasotoaguilar"
  version: "1.5"
allowed-tools: Bash(tvly *)
---

## Execution Role

EXECUTION ADAPTER: `research` owns source routing and synthesis; this skill only executes `tvly` commands. On a parent research handoff, run the capability research routed and return raw results — do not route, scope, or synthesize on your own. Direct activation is reserved for explicit `tvly`/Tavily CLI requests, never generic web research.

## Activation Contract

Use when executing Tavily CLI capabilities: web search, URL content extraction, site URL mapping, domain crawling, or deep multi-source research. Loaded by `research` for Tavily routes, or on explicit `tvly` requests.

## Hard Rules

- `tvly` MUST be on PATH. If missing, report it and stop — no install, no fallback within this skill.
- Choose exactly ONE capability by current need. Compose a second capability only when evidence from the first requires it (e.g., map found a URL → extract it). Never force the search → extract → map → crawl → research chain.
- Auth gate: `search`/`extract` work rate-limited without a key; `map`, `crawl`, and `research` require `tvly login` or `TAVILY_API_KEY`. Report when auth is missing.
- Bounds: max 20 URLs per `extract` call; `--chunks-per-source` is 1-5 and requires `--query` (extract) or `--instructions` (crawl); always set `--limit` on map/crawl.
- Load ONLY the reference matching the chosen capability; never load all references.

## Decision Gates

| Intent                                                       | Capability                                                     | Load reference           |
| ------------------------------------------------------------ | -------------------------------------------------------------- | ------------------------ |
| Search web, no URL yet, quick facts, news, current info      | `search` (recommended starting point when sources are unknown) | `references/search.md`   |
| Content of specific URL(s), JS-rendered pages, clean text    | `extract`                                                      | `references/extract.md`  |
| List site URLs, find a page on a known site, site structure  | `map`                                                          | `references/map.md`      |
| Many pages from one site, bulk docs download, local markdown | `crawl`                                                        | `references/crawl.md`    |
| Deep multi-source synthesis, report, comparison, citations   | `research`                                                     | `references/research.md` |

## Execution Steps

1. Classify the request with the Decision Gates table; choose exactly one capability.
2. Load the matching reference and follow its option tables.
3. Confirm `tvly` on PATH and auth for the chosen capability (Hard Rules); if missing, report and stop.
4. Run the command with explicit limits (`--max-results`, `--limit`, `--timeout`).
5. Compose a second capability only when this run's evidence requires it; otherwise stop.

## Output Contract

Return:

- The exact command and capability used.
- The result or artifact path (`-o` / `--output-dir`).
- Coverage and limits: URLs processed, pages mapped/crawled, auth status, truncation.
- A next capability ONLY when evidence from this run requires it — no generic "suggest next step".

## References

- `references/search.md` — search: options, depth, tips.
- `references/extract.md` — extract: options, chunking, depth.
- `references/map.md` — map: options, map + extract pattern.
- `references/crawl.md` — crawl: options, context vs data collection.
- `references/research.md` — research: options, models, async workflow.

# Tavily search

Web search returning LLM-optimized results with content snippets and relevance scores. Router, auth, and bounds live in `../SKILL.md`; this file covers only the `search` capability.

## When to use

- You need to find information and have no specific URL yet.
- Quick facts, news, current information.
- Recommended starting point when sources are unknown — not a mandatory first step.

## Quick start

```bash
# Basic search
tvly search "your query" --json

# Advanced search with more results
tvly search "quantum computing" --depth advanced --max-results 10 --json

# Recent news, domain-filtered
tvly search "AI news" --time-range week --topic news --json
tvly search "SEC filings" --include-domains sec.gov,reuters.com --json

# Include full page content in results (saves a separate extract call)
tvly search "react hooks" --include-raw-content markdown --max-results 3 --json
```

## Options

| Option                                              | Description                                         |
| --------------------------------------------------- | --------------------------------------------------- |
| `--depth`                                           | `ultra-fast`, `fast`, `basic` (default), `advanced` |
| `--max-results`                                     | Max results, 0-20 (default: 5)                      |
| `--topic`                                           | `general` (default), `news`, `finance`              |
| `--time-range`                                      | `day`, `week`, `month`, `year`                      |
| `--start-date` / `--end-date`                       | Results after/before date (YYYY-MM-DD)              |
| `--include-domains` / `--exclude-domains`           | Comma-separated domains to include/exclude          |
| `--country`                                         | Boost results from country                          |
| `--include-answer`                                  | Include AI answer (`basic` or `advanced`)           |
| `--include-raw-content`                             | Include full page content (`markdown` or `text`)    |
| `--include-images` / `--include-image-descriptions` | Include image results / AI image descriptions       |
| `--chunks-per-source`                               | Chunks per source (advanced/fast depth only)        |
| `-o, --output`                                      | Save output to file                                 |
| `--json`                                            | Structured JSON output                              |

## Search depth

| Depth        | Speed   | Relevance | Best for                     |
| ------------ | ------- | --------- | ---------------------------- |
| `ultra-fast` | Fastest | Lower     | Real-time chat, autocomplete |
| `fast`       | Fast    | Good      | Need chunks, latency matters |
| `basic`      | Medium  | High      | General-purpose (default)    |
| `advanced`   | Slower  | Highest   | Precision, specific facts    |

## Tips

- Think search query, not prompt; break complex queries into sub-queries.
- `--include-raw-content` gives full page text when you need it.
- `--include-domains` focuses on trusted sources; `--time-range` for recency.
- Read from stdin: `echo "query" | tvly search - --json`

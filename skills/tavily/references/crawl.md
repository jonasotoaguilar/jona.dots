# Tavily crawl

Crawl a website and extract content from multiple pages. Supports saving each page as a local markdown file. Router, auth, and bounds live in `../SKILL.md`; this file covers only the `crawl` capability.

## When to use

- You need content from many pages on a site (e.g., all `/docs/`).
- You want to download documentation for offline use.
- Requires an API key (`tvly login` or `TAVILY_API_KEY`).

## Quick start

```bash
# Basic crawl
tvly crawl "https://docs.example.com" --json

# Save each page as a markdown file
tvly crawl "https://docs.example.com" --output-dir ./docs/

# Deeper crawl with limits and path filters
tvly crawl "https://docs.example.com" --max-depth 2 --limit 50 --json
tvly crawl "https://example.com" --select-paths "/api/.*,/guides/.*" --exclude-paths "/blog/.*" --json

# Semantic focus (returns relevant chunks, not full pages)
tvly crawl "https://docs.example.com" --instructions "Find authentication docs" --chunks-per-source 3 --json
```

## Options

| Option                                   | Description                                          |
| ---------------------------------------- | ---------------------------------------------------- |
| `--max-depth`                            | Levels deep (1-5, default: 1)                        |
| `--max-breadth`                          | Links per page (default: 20)                         |
| `--limit`                                | Total pages cap (default: 50)                        |
| `--instructions`                         | Natural language guidance for semantic focus         |
| `--chunks-per-source`                    | Chunks per page (1-5, requires `--instructions`)     |
| `--extract-depth`                        | `basic` (default) or `advanced`                      |
| `--format`                               | `markdown` (default) or `text`                       |
| `--select-paths` / `--exclude-paths`     | Comma-separated regex patterns to include/exclude    |
| `--select-domains` / `--exclude-domains` | Comma-separated regex for domains to include/exclude |
| `--allow-external / --no-external`       | Include external links (default: allow)              |
| `--include-images`                       | Include images                                       |
| `--timeout`                              | Max wait (10-150 seconds)                            |
| `-o, --output`                           | Save JSON output to file                             |
| `--output-dir`                           | Save each page as a .md file in directory            |
| `--json`                                 | Structured JSON output                               |

## Crawl for context vs. data collection

**For agentic use** (feeding results to an LLM): always use `--instructions` + `--chunks-per-source`. Returns only relevant chunks instead of full pages — prevents context explosion.

```bash
tvly crawl "https://docs.example.com" --instructions "API authentication" --chunks-per-source 3 --json
```

**For data collection** (saving to files): use `--output-dir` without `--chunks-per-source` to get full pages as markdown files.

```bash
tvly crawl "https://docs.example.com" --max-depth 2 --output-dir ./docs/
```

## Tips

- Always set `--limit` to prevent runaway crawls.
- Start conservative — `--max-depth 1`, `--limit 20` — and scale up.
- Use `--select-paths` to focus on the section you need.
- Use map first to understand site structure before a full crawl.

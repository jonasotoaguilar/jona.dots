# Tavily extract

Extract clean markdown or text content from one or more URLs. Router, auth, and bounds live in `../SKILL.md`; this file covers only the `extract` capability.

## When to use

- You have a specific URL and want its content.
- You need text from JavaScript-rendered pages.

## Quick start

```bash
# Single or multiple URLs
tvly extract "https://example.com/article" --json
tvly extract "https://example.com/page1" "https://example.com/page2" --json

# Query-focused extraction (returns relevant chunks only)
tvly extract "https://example.com/docs" --query "authentication API" --chunks-per-source 3 --json

# JS-heavy pages
tvly extract "https://app.example.com" --extract-depth advanced --json

# Save to file
tvly extract "https://example.com/article" -o article.md
```

## Options

| Option                | Description                                    |
| --------------------- | ---------------------------------------------- |
| `--query`             | Rerank chunks by relevance to this query       |
| `--chunks-per-source` | Chunks per URL (1-5, requires `--query`)       |
| `--extract-depth`     | `basic` (default) or `advanced` (for JS pages) |
| `--format`            | `markdown` (default) or `text`                 |
| `--include-images`    | Include image URLs                             |
| `--timeout`           | Max wait time (1-60 seconds)                   |
| `-o, --output`        | Save output to file                            |
| `--json`              | Structured JSON output                         |

## Extract depth

| Depth      | When to use                               |
| ---------- | ----------------------------------------- |
| `basic`    | Simple pages, fast — try this first       |
| `advanced` | JS-rendered SPAs, dynamic content, tables |

## Tips

- Max 20 URLs per request — batch larger lists into multiple calls.
- `--query` + `--chunks-per-source` returns only relevant content instead of full pages.
- Try `basic` first, fall back to `advanced` if content is missing.
- Set `--timeout` for slow pages (up to 60s).
- If search results already contain the content (via `--include-raw-content`), skip the extract step.

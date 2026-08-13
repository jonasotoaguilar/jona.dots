# Tavily map

Discover URLs on a website without extracting content. Faster than crawling. Router, auth, and bounds live in `../SKILL.md`; this file covers only the `map` capability.

## When to use

- You need to find a specific subpage on a large site.
- You want a list of all URLs before deciding what to extract or crawl.
- Requires an API key (`tvly login` or `TAVILY_API_KEY`).

## Quick start

```bash
# Discover all URLs
tvly map "https://docs.example.com" --json

# With natural language filtering
tvly map "https://docs.example.com" --instructions "Find API docs and guides" --json

# Filter by path, deep map
tvly map "https://example.com" --select-paths "/blog/.*" --limit 500 --json
tvly map "https://example.com" --max-depth 3 --limit 200 --json
```

## Options

| Option                                   | Description                                          |
| ---------------------------------------- | ---------------------------------------------------- |
| `--max-depth`                            | Levels deep (1-5, default: 1)                        |
| `--max-breadth`                          | Links per page (default: 20)                         |
| `--limit`                                | Max URLs to discover (default: 50)                   |
| `--instructions`                         | Natural language guidance for URL filtering          |
| `--select-paths` / `--exclude-paths`     | Comma-separated regex patterns to include/exclude    |
| `--select-domains` / `--exclude-domains` | Comma-separated regex for domains to include/exclude |
| `--allow-external / --no-external`       | Include external links                               |
| `--timeout`                              | Max wait (10-150 seconds)                            |
| `-o, --output`                           | Save output to file                                  |
| `--json`                                 | Structured JSON output                               |

## Map + Extract pattern

Use `map` to find the right page, then `extract` it — often more efficient than crawling the whole site:

```bash
# Step 1: Find the authentication docs
tvly map "https://docs.example.com" --instructions "authentication" --json

# Step 2: Extract the specific page you found
tvly extract "https://docs.example.com/api/authentication" --json
```

## Tips

- Map is URL discovery only — no content extraction. Use `extract` or `crawl` for content.
- Map + extract beats crawl when you only need a few specific pages from a large site.
- Use `--instructions` for semantic filtering when path patterns aren't enough.

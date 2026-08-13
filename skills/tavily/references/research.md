# Tavily research

AI-powered deep research that gathers sources, analyzes them, and produces a cited report. Router, auth, and bounds live in `../SKILL.md`; this file covers only the `research` capability.

## When to use

- You need comprehensive, multi-source analysis.
- The user wants a comparison, market report, or literature review.
- Quick searches aren't enough — you need synthesis with citations.
- Requires an API key (`tvly login` or `TAVILY_API_KEY`).

## Quick start

```bash
# Basic research (waits for completion)
tvly research "competitive landscape of AI code assistants"

# Pro model for comprehensive analysis
tvly research "electric vehicle market analysis" --model pro

# Stream results in real-time
tvly research "AI agent frameworks comparison" --stream

# Save report to file
tvly research "fintech trends" --model pro -o fintech-report.md

# JSON output for agents
tvly research "quantum computing breakthroughs" --json
```

## Options

| Option              | Description                               |
| ------------------- | ----------------------------------------- |
| `--model`           | `mini`, `pro`, or `auto` (default)        |
| `--stream`          | Stream results in real-time               |
| `--no-wait`         | Return request_id immediately (async)     |
| `--output-schema`   | Path to JSON schema for structured output |
| `--citation-format` | `numbered`, `mla`, `apa`, `chicago`       |
| `--poll-interval`   | Seconds between checks (default: 10)      |
| `--timeout`         | Max wait seconds (default: 600)           |
| `-o, --output`      | Save output to file                       |
| `--json`            | Structured JSON output                    |

## Model selection

| Model  | Use for                            |
| ------ | ---------------------------------- |
| `mini` | Single-topic, targeted research    |
| `pro`  | Comprehensive multi-angle analysis |
| `auto` | API chooses based on complexity    |

**Rule of thumb:** "What does X do?" → mini. "X vs Y vs Z" or "best way to..." → pro.

## Async workflow

For long-running research, start and poll separately:

```bash
# Start without waiting
tvly research "topic" --no-wait --json    # returns request_id

# Check status
tvly research status <request_id> --json

# Wait for completion
tvly research poll <request_id> --json -o result.json
```

## Methodology

For multi-source research, plan before running:

1. **Decompose**: break the topic into 3-5 research sub-questions.
2. **Source quality**: prioritize official, academic, and reputable sources over blogs and forums.
3. **Breadth**: use 2-3 keyword variations per sub-question; mix general and news-focused queries.
4. **Deep-read**: read 3-5 key sources in full; do not rely on search snippets alone.
5. **Fact vs inference**: label estimates, projections, and opinions clearly; flag single-source claims as unverified; say so when a sub-question yields nothing.
6. **Cite**: every claim needs a source; prefer recent sources when the topic moves quickly.

## Report structure

Keep reports concise and scannable:

- Executive summary (3-5 sentences).
- Findings grouped by theme, with inline citations.
- Key takeaways.
- Sources with one-line summaries.
- Methodology note: sub-questions investigated, sources analyzed.

## Tips

- Use `--stream` to see progress in real-time.
- Use `--model pro` for complex comparisons or multi-faceted topics.
- Use `--output-schema` to get structured JSON output matching a custom schema.
- For quick facts, use `tvly search` instead — research is for deep synthesis.
- Read from stdin: `echo "query" | tvly research - --json`

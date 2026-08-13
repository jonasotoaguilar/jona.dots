#!/usr/bin/env python3
"""Validate a generated OpenAPI schema for required sections."""

from pathlib import Path
import argparse
import sys

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML required. Install with: pip install pyyaml", file=sys.stderr)
    sys.exit(1)

DEFAULT_REQUIRED = [
    "openapi",
    "info",
    "servers",
    "paths",
    "components",
    "securitySchemes",
]

NESTED_KEYS = {
    "securitySchemes": ["components", "securitySchemes"],
}


def key_exists(data, key):
    if key in NESTED_KEYS:
        parts = NESTED_KEYS[key]
        cur = data
        for part in parts:
            if not isinstance(cur, dict) or part not in cur:
                return False
            cur = cur[part]
        return True
    return key in data


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a generated artifact.")
    parser.add_argument("--input", default="openapi.yaml", help="Input file path")
    parser.add_argument(
        "--require",
        action="append",
        default=[],
        help="Additional required section heading",
    )
    args = parser.parse_args()

    path = Path(args.input)
    if not path.exists():
        print(f"Missing file: {path}", file=sys.stderr)
        return 1

    try:
        text = path.read_text(encoding="utf-8")
    except (UnicodeDecodeError, LookupError) as e:
        print(f"Decoding error: {e}", file=sys.stderr)
        return 1

    try:
        data = yaml.safe_load(text)
    except yaml.YAMLError as e:
        print(f"Malformed YAML: {e}", file=sys.stderr)
        return 1

    if not isinstance(data, dict):
        print(f"Root must be a mapping, got {type(data).__name__}", file=sys.stderr)
        return 1

    required = DEFAULT_REQUIRED + args.require
    missing = [key for key in required if not key_exists(data, key)]
    if missing:
        print("Missing required sections: " + ", ".join(missing), file=sys.stderr)
        return 1

    print(f"Validated {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

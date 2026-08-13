# Mutation Testing Frameworks

Compact selection reference for the sdd-verify mutation support check.

**Tool policy:** prefer the framework ALREADY present in the project (lockfile, config, CI). NEVER install without authorization: framework missing → typed `unavailable` evidence with the preserved error; never substitute manual mutation analysis. Optional enhancers (run when available, never block, never install silently): Trailmark for reachability/blast-radius context, Necessist for weak-assertion detection.

## Selection Table

| Stack / language                       | Recommended framework                   |
| -------------------------------------- | --------------------------------------- |
| Python                                 | pytest-gremlins or mutmut               |
| JavaScript / TypeScript                | Stryker                                 |
| Rust                                   | cargo-mutants                           |
| Go                                     | gremlins or go-mutesting                |
| Java                                   | PITest                                  |
| C / C++                                | Mull                                    |
| C#                                     | Stryker.NET                             |
| Ruby                                   | mutant                                  |
| PHP                                    | Infection                               |
| Solidity                               | slither-mutate                          |
| Circom                                 | circomvent                              |
| Cairo                                  | cairo-mutants                           |
| Haskell                                | MuCheck (or Hedgehog as mutation proxy) |
| TON smart contracts (Tact, Tolk, FunC) | muton                                   |

## Normalization Notes

- **Statuses:** normalize framework statuses to the universal vocabulary `killed` / `survived` / `timeout` / `skipped`; filter to `survived` for triage. `Skipped` (superseded by a more severe mutant on the same line) is not a finding.
- **Targeted rerun:** only mewt/muton support targeted mutant rerun (`mewt test --ids [ids]`; IDs resolved via `mewt print mutants --target` + verified with `mewt print mutant --id`). For every other framework, incremental candidates fall back to full.
- **Parsing:** parse ONLY output formats the installed tool demonstrably emits (stable help/status); never invent a parse schema. Raw tool output never enters the manifest.
- **Seeds:** set and record a deterministic seed only when the framework documents one; never invent seed flags. No seed support → `seed: null`.
- **Record:** normalize every survived mutant to `{file_path, line, mutation_type, original, replacement, function_name, status}`; these fields feed the manifest `survivors[]` entries and `stable_id` canonicalization (`references/evidence-manifest.md`).

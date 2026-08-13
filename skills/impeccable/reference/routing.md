# Command index and no-argument routing

Lazy reference: load this file when the user invokes `/impeccable` with no argument, or to resolve a command to its reference. The main SKILL.md carries the intent groups; this file maps every explicit command to its playbook.

Intent groups: Build (`shape`, `init`, `document`, `extract`), Evaluate (`critique`, `audit`), Refine (`polish`, `bolder`, `quieter`, `distill`, `harden`, `onboard`), Enhance (`animate`, `colorize`, `typeset`, `layout`, `delight`, `overdrive`), Fix (`clarify`, `adapt`, `optimize`), Iterate (`live`).

## Command → reference index

| Command              | Intent                                                   | Reference                              |
| -------------------- | -------------------------------------------------------- | -------------------------------------- |
| `shape [feature]`    | Plan UX/UI before code; user-confirmed brief             | `shape.md`                             |
| `init`               | Capture durable product context in PRODUCT.md            | `init.md`                              |
| `document`           | Extract visual evidence; typed payload → `documentation` | `document.md`                          |
| `extract [target]`   | Pull reusable tokens/components into the design system   | `extract.md`                           |
| `critique [target]`  | UX design review with heuristic scoring                  | `critique.md`                          |
| `audit [target]`     | Technical quality checks (a11y, perf, responsive)        | `audit.md` · native: `audit.native.md` |
| `polish [target]`    | Final quality pass before shipping                       | `polish.md`                            |
| `bolder [target]`    | Amplify safe or bland designs                            | `bolder.md`                            |
| `quieter [target]`   | Tone down aggressive designs                             | `quieter.md`                           |
| `distill [target]`   | Strip to essence                                         | `distill.md`                           |
| `harden [target]`    | Production-ready: errors, i18n, edge cases               | `harden.md`                            |
| `onboard [target]`   | First-run flows, empty states, activation                | `onboard.md`                           |
| `animate [target]`   | Purposeful motion (mechanics → `ui-motion`)              | `animate.md`                           |
| `colorize [target]`  | Strategic color for monochromatic UIs                    | `colorize.md`                          |
| `typeset [target]`   | Typography hierarchy and fonts                           | `typeset.md`                           |
| `layout [target]`    | Spacing, rhythm, visual hierarchy                        | `layout.md`                            |
| `delight [target]`   | Personality and memorable touches                        | `delight.md`                           |
| `overdrive [target]` | Push past conventional limits                            | `overdrive.md`                         |
| `clarify [target]`   | UX copy, labels, error messages                          | `clarify.md`                           |
| `adapt [target]`     | Different devices/screen sizes                           | `adapt.md` · native: `adapt.native.md` |
| `optimize [target]`  | Diagnose and fix UI performance                          | `optimize.md`                          |
| `live`               | In-browser variant iteration (web only)                  | `live.md`                              |
| `craft` (deprecated) | Alias for ordinary new-work; adds nothing                | `craft.md`                             |

Native platforms (`ios`/`android`/`adaptive`) load the native variant reference and the platform guides (`ios.md`, `android.md`).

## No-argument routing: the context-aware menu

Read this when the user invokes `/impeccable` with no argument — they are asking "what should I do?" Make the menu context-aware instead of static.

`context.mjs` has already run once (read-only). If it reported `NO_PRODUCT_MD`, the project has no captured context: lead the menu with `/impeccable init` as the top recommendation (one line on why) and still show the rest below; don't silently jump into init. Otherwise run `node .opencode/skills/impeccable/scripts/
context-signals.mjs` once and read its JSON, then lead with the 2-3 highest-value next commands, each with a one-line reason pulled from the signals, followed by the full menu (the index above, grouped by category). **Never auto-run a command; the recommendation is a suggestion the user confirms.**

Reason over the signals; there is no score to obey:

- `setup.hasDesign` false while `setup.hasCode` true → `document` (extract visual evidence; missing decisions route to `design-ui`, `documentation` writes DESIGN.md).
- `critique.latest` is `null` → the project has never been critiqued; for a set-up project with a real surface, `critique <surface>` is a strong default.
- `critique.latest` with a low `score` or non-zero `p0`/`p1` → `polish` (it reads that snapshot as its backlog), or re-run `critique` if the snapshot looks stale.
- `git.changedFiles` pointing at one surface → scope `audit` or `polish` to those files specifically.
- `devServer.running` true → `live` is available; if false, don't lead with it. `live` and the bundled `detect.mjs` are web-only; on `ios`/`android`/ `adaptive` platforms don't lead with either.
- Otherwise group by intent (build new / improve what's there / iterate visually), tailored to the current surface and `setup.platform`.

**If `scan.targets` is non-empty and the platform is not native**, run `node
.opencode/skills/impeccable/scripts/detect.mjs --json <scan.targets joined by
spaces>` once (local detector over HTML/CSS; no network, no npx). Fold the hits into your picks: many quality/contrast hits → `audit` or `polish`; a specific slop family → the matching command (gradient text → `quieter`/`typeset`, flat or gray palette → `colorize`). If detect errors or the tree is too large, skip it and recommend `audit` instead; never block the suggestion on it.

Keep it to 2-3 pointed picks with the exact command to type. The menu stays the fallback; the recommendation is the lede.

# Watchlist: watch / reject / deprecated / ambiguous

Load ONLY when evaluating a risky, deprecated, or ambiguous candidate. Reassessment notes track why each entry sits here. Snapshot: 2026-08. See `../../SKILL.md` for activation and lazy-load rules.

## Watch (evaluate before use)

| Entry | Why it's here | Reassessment note |
| --- | --- | --- |
| [Material Web](https://material-web.dev) | Official Google Material 3 web components are in maintenance mode | Reassess if Google resumes active development |
| [VengeanceUI](https://vengeanceui.com) | Overlap with Magic UI / core catalogs; low maturity | Verify maintenance cadence before adoption |
| [Forge UI](https://forgeui.com) | Low maturity, uncertain maintenance | Reassess after stable release |
| UI Lora | Low maturity / licensing uncertainty | Site unreachable at validation (2026-08); URL unresolved — verify the project before use |
| [Boneyard](https://boneyard.dev) | Young skeleton generator | Verify maturity before relying on it |
| [expo-maps](https://docs.expo.dev/versions/latest/sdk/maps/) | Younger than react-native-maps | Favor react-native-maps until expo-maps stabilizes |
| [@expo/ui](https://docs.expo.dev/versions/latest/sdk/ui/) community bottom sheet | Not core @expo/ui functionality | Use @gorhom/bottom-sheet instead |
| [UniWind](https://docs.uniwind.dev) | Young styling engine | Reassess maturity before adoption |
| [React Strict DOM](https://github.com/facebook/react-strict-dom) | Experimental | Not for production new work |

## Unresolved / ambiguous

| Entry | Status |
| --- | --- |
| Universe | Ambiguous/unverified; NOT added as a recommendation. Recorded here until licensing, scope, and maintenance are verified |

## Reject for new work (dead / maintenance-stopped)

| Entry | Notes |
| --- | --- |
| NativeBase | Maintenance stopped |
| react-native-chart-kit | Effectively unmaintained |
| UI Kitten | Abandoned |
| twrnc (tailwind-react-native-classnames) | Superseded by NativeWind |
| Supahero as a dependency | Merged into ScreensDesign; inspiration only, never install |

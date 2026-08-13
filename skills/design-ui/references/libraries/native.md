# Expo / React Native picks

Native-specific catalog, explicitly separate from web-only recommendations in `web.md`. A web pick is NOT automatically the right native pick — check the mismatch mappings below. Snapshot: 2026-08. See `../../SKILL.md` for activation and lazy-load rules.

## Core picks

| Task | Library |
| --- | --- |
| Native UI primitives & components | [@expo/ui](https://docs.expo.dev/versions/latest/sdk/ui/) |
| Tailwind-style styling | [NativeWind](https://www.nativewind.dev) |
| Animations | [react-native-reanimated](https://docs.swmansion.com/react-native-reanimated/) + [react-native-gesture-handler](https://docs.swmansion.com/react-native-gesture-handler/) |
| Long lists (virtualization) | [FlashList](https://shopify.github.io/flash-list/) |
| Forms | [react-hook-form](https://react-hook-form.com) + [zod](https://zod.dev) |
| Bottom sheets | [@gorhom/bottom-sheet](https://gorhom.github.io/react-native-bottom-sheet/) |
| Icons | [lucide-react-native](https://lucide.dev) / [@expo/vector-icons](https://docs.expo.dev/guides/icons/) |
| Charts | [Victory Native XL](https://commerce.nearform.com/open-source/victory-native/) |
| Maps | [react-native-maps](https://github.com/react-native-maps/react-native-maps) |
| Images | [expo-image](https://docs.expo.dev/versions/latest/sdk/image/) |
| Routing | [expo-router](https://docs.expo.dev/router/introduction/) |
| Safe areas & keyboard | [react-native-safe-area-context](https://github.com/AppAndFlow/react-native-safe-area-context) + [react-native-keyboard-controller](https://github.com/kirillzyusko/react-native-keyboard-controller) |

## Specialists

| Task | Library |
| --- | --- |
| Unstyled accessible primitives (base-ui/Radix equivalent) | [@rn-primitives/react-native-reusables](https://github.com/founded-labs/react-native-reusables) |
| Headless UI kits | [gluestack-ui](https://gluestack.io) |
| Material Design components | [react-native-paper](https://callstack.github.io/react-native-paper/) |
| Full styling + component system | [Tamagui](https://tamagui.dev) |
| Lightweight animations | [Moti](https://moti.fyi) |
| 2D graphics / advanced drawing | [React Native Skia](https://shopify.github.io/react-native-skia/) |
| Charts (gifted alternative) | [gifted-charts](https://gifted-charts.web.app) |
| Shared web/native navigation code | [Solito](https://solito.dev) (only where shared code matters) |

## Web ↔ native mismatch mappings

| Web pick | Native replacement |
| --- | --- |
| recharts | Victory Native XL |
| Virtuoso / large FlatList | FlashList |
| base-ui / Radix | @rn-primitives/react-native-reusables |
| motion (Framer Motion) | Moti / Reanimated |
| dnd-kit | No direct equivalent — design native drag UX (long-press) or use Reanimated-based gesture solutions |
| Web-only assumptions (hover, pointer events, viewport units) | Do not port directly — rethink for touch |

## Install rules

- Install native deps with `npx expo install` (resolves compatible versions), then run `npx expo-doctor` to verify health.
- Verify Expo Go vs dev-build compatibility before relying on a native module (check the module's docs for Expo Go support).

## Watchlist / rejected

Watch: [expo-maps](https://docs.expo.dev/versions/latest/sdk/maps/) (maturity), [@expo/ui](https://docs.expo.dev/versions/latest/sdk/ui/) community bottom sheet (not core), [UniWind](https://docs.uniwind.dev) (young), [React Strict DOM](https://github.com/facebook/react-strict-dom) (experimental).

Reject for new work: NativeBase, react-native-chart-kit, UI Kitten, twrnc (dead/maintenance-stopped). Details in `watchlist.md`.

# Mobile Reference Comp Direction (brief-driven)

Art direction for mobile app screen/flow comps produced FROM an approved design brief. Images only — never code, never SwiftUI/React Native/Flutter/HTML, never a website in a phone. Applies quality.md gates on top.

## Scope

For: onboarding, auth, home dashboards, profile, settings, chat, ecommerce, fintech, health/fitness, productivity, social, utilities, multi-screen concepts, redesigns — as briefed. Not for: websites, landing pages, desktop dashboards, implementation.

## Platform Mode (decide from the brief/target)

Pick ONE: iOS-native premium (clean top areas, tab-bar clarity, safe-area awareness, elegant spacing, restrained chrome); Android-native premium (stronger component rhythm, clear app-bar/bottom-nav, sheet logic, firmer framing); cross-platform premium neutral (clean safe-area, universal nav patterns, broadly buildable). Never mix iOS and Android patterns carelessly.

## Screen-First & Volume Rules

- Generate the screen set directly — never answer with text-only, never collapse a requested flow into one collage.
- Screen count follows the brief: 1 request → 1 image; N screens → N images; onboarding → multiple distinct screens; auth → sign-in/sign-up/recovery states; an app concept → a meaningful set, not one hero mockup. Prefer several clean readable screens over one compressed board with tiny text. Never reduce count for convenience.

## App Design Bible (lock before multi-screen sets)

Keep consistent across the whole set: platform mode, device frame style + scale, palette logic, typography mood + scale rhythm, spacing system, corner radius logic, icon style, illustration/imagery treatment, texture intensity, navigation model, card/list behavior, button styling, shadow language. Screens 3–5 must not drift into a different app.

## Consistency & Flow

- Multi-screen consistency is mandatory: brand mood, type hierarchy, palette, safe-area, navigation, component family, surface/card/background logic, image framing, device frame presentation. Variation allowed in composition, feature emphasis, image placement, purpose, visual tempo — never in product identity, design system, mockup quality, core spacing.
- Logical flow: onboarding → auth → home; home → browse → detail; profile → settings; cart → checkout → confirmation; etc. Each screen answers "why does this come after the previous?" The set must read as a real walkthrough.

## Mockup Framing (conditional)

- Present UI inside a clean device mockup (iPhone-style for iOS/neutral, Android-style for Android) when the brief or deliverable needs device context.
- Render screen-only output when the brief asks for UI sheets/assets, or borderless serves the concept.
- Frame rules when used: one coherent device style + scale per set; centered/clearly aligned; even outer margins; no touching canvas edges; no cropped frames; soft controlled shadows; content stays the hero — the mockup supports, never dominates. Multiple devices: same scale, equal gutters, clean alignment.

## Screen-Level Gates

- **First screen** (onboarding/home/auth/intro): calm, immediately readable; one focal point; 1–3 short headline lines; concise support; one clear next action; no stats/chips/tags/pills overload; image-behind-text protected with fades/masks/scrims.
- **Safe areas**: design with status bar, top/title region, bottom navigation, home indicator, sheet docking zone, gesture space in mind. No content crammed into unsafe areas.
- **Navigation**: tab bar/bottom nav for major sections, stack feel for drill-downs, sheets for secondary tasks, segmented controls for local switching, clear primary/secondary actions.
- **Clean layout**: no box-in-box-in-box, giant nested card stacks, floating surfaces everywhere, fake OS labels, decorative pills. Prefer fewer clearer containers, direct hierarchy, one strong structural move.
- **Imagery**: deliberate and category-matched; no lazy filler thumbnails, no one-pretty-screen-then-nothing.
- **Typography & text**: short clean copy, believable button labels, no lorem ipsum, no inspirational filler. Text must never feel small — if it does, simplify layout, reduce content, increase spacing, enlarge type, or regenerate.
- **Spacing/density**: generous spacing, calm density; separate dense screens with calmer ones.
- **Not always simple**: richness, layering, atmosphere are allowed as long as everything stays clean and readable. "Not always simple; always clean."

## Delivery

Apply quality.md clarity and consistency gates before delivering; output the full screen set and never switch to coding mode.

# Swatch — project context for Claude Code

Read this before making changes. Full detail lives in `docs/BRD-motion-library-app.md` and `docs/PRD-motion-library-app.md` — read those too if a decision here seems underspecified.

## What this is

An iOS app cataloguing UI micro-interactions, each rendered live in SwiftUI, for browsing and saving favourites. Personal portfolio project, built by a UI/UX designer with minimal coding experience, a few hours a week, no deadline.

## Hard rules — do not violate these

1. **One animation, one file.** Every motion in the catalogue gets its own SwiftUI file. Adding a new animation must never require editing an existing animation's file. This is the single most important architectural constraint in the project (PRD F6).
2. **No third-party packages.** Native SwiftUI only. The dev machine has 8GB RAM — dependency resolution and larger builds are genuinely costly here, not just a preference.
3. **Icons come from SF Symbols only.** Use `Image(systemName:)` with Apple's built-in symbol names exclusively — no custom icon assets, no third-party icon sets, no hand-drawn SVGs. If a suitable SF Symbol doesn't exist for something, say so and suggest the closest match rather than substituting a custom asset. This keeps the catalogue's "add one entry, no asset production" property intact (F6) and matches P3 in the PRD.
4. **Stock iOS components only, styled with iOS 26 Liquid Glass.** System typography, semantic colors, standard navigation (`NavigationStack`, `TabView`). No custom chrome — but "stock" now means the current system look: use SwiftUI's `.glassEffect()` modifier and `GlassEffectContainer` on toolbar buttons, the tab bar, and floating controls, rather than plain fills or hand-rolled opacity/blur. Tab bar should read as a floating pill, not a flush bottom bar. If `.glassEffect()` isn't available or behaves unexpectedly, say so rather than approximating it with manual opacity — an approximation looks similar but won't respond to content/light the way the real material does.
5. **No SwiftData, no CoreData, no backend, no network calls.** Favourites are a `Set<String>` of motion IDs in `UserDefaults`. Nothing more.
6. **Portrait only, iPhone only, light mode is the tested target.** Don't build for iPad, landscape, or dark mode — don't deliberately break dark mode either, just don't spend effort on it.

## Working style

- Explain what you changed and why, briefly, after any nontrivial edit — the person reviews every diff before accepting it and needs to actually understand it, not just approve it.
- Prefer small, focused changes over large multi-file rewrites. Sessions are ~90 minutes; changes should be reviewable in that window.
- When implementing an animation, match the spring/timing values already specified in that motion's entry in `Motion.swift` (the `concept` field) rather than inventing new ones — those values came from a spec, not from you.
- If a request would violate one of the hard rules above, say so and ask before proceeding, rather than working around it silently.

## Current state

Check `docs/PRD-motion-library-app.md` §9 (Build Sequence) for which session-numbered milestone is next. Update this file's "Current state" note as sessions complete, so future sessions don't need to be re-explained from scratch.

<!-- Update below as you progress -->
Last completed: Session 4 — first animation (press scale) implemented on DetailView.

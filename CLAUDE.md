# Swatch — project context for Claude Code

Read this before making changes. Full detail lives in `docs/BRD-motion-library-app.md` and `docs/PRD-motion-library-app.md` — read those too if a decision here seems underspecified.

## What this is

An iOS app cataloguing UI micro-interactions, each rendered live in SwiftUI, for browsing and saving favourites. Personal portfolio project, built by a UI/UX designer with minimal coding experience, a few hours a week, no deadline.

## Hard rules — do not violate these

1. **One animation, one file.** Every motion in the catalogue gets its own SwiftUI file. Adding a new animation must never require editing an existing animation's file. This is the single most important architectural constraint in the project (PRD F6).
2. **No third-party packages.** Native SwiftUI only. The dev machine has 8GB RAM — dependency resolution and larger builds are genuinely costly here, not just a preference.
3. **Stock iOS components only.** System fonts, SF Symbols, semantic colors, standard navigation (`NavigationStack`, `TabView`). No custom chrome. The motion is the only thing that should stand out on screen.
4. **No SwiftData, no CoreData, no backend, no network calls.** Favourites are a `Set<String>` of motion IDs in `UserDefaults`. Nothing more.
5. **Portrait only, iPhone only, light mode is the tested target.** Don't build for iPad, landscape, or dark mode — don't deliberately break dark mode either, just don't spend effort on it.

## Working style

- Explain what you changed and why, briefly, after any nontrivial edit — the person reviews every diff before accepting it and needs to actually understand it, not just approve it.
- Prefer small, focused changes over large multi-file rewrites. Sessions are ~90 minutes; changes should be reviewable in that window.
- When implementing an animation, match the spring/timing values already specified in that motion's entry in `Motion.swift` (the `concept` field) rather than inventing new ones — those values came from a spec, not from you.
- If a request would violate one of the hard rules above, say so and ask before proceeding, rather than working around it silently.

## Current state

Check `docs/PRD-motion-library-app.md` §9 (Build Sequence) for which session-numbered milestone is next. Update this file's "Current state" note as sessions complete, so future sessions don't need to be re-explained from scratch.

<!-- Update below as you progress -->
Last completed: Session 4 — first animation (press scale) implemented on DetailView.

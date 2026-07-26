# Product Requirements Document

**Project:** Swatch — iOS motion library app
**Version:** 1.0 — Draft for review
**Date:** 25 July 2026
**Author:** Athina
**Parent document:** BRD v0.1
**Status:** Awaiting review before design stage

---

## 1. Purpose

This document translates the BRD's business objectives into buildable requirements: what screens exist, what each one does, which animations ship in v1, and how you will know when each piece is finished.

It is written to be read in two ways — as a specification, and as a build plan. Section 9 maps every requirement onto roughly 90-minute working sessions, because per BRD R1, momentum is the project's main risk.

Anything not specified here is out of scope. Anything specified here but not in the BRD's v1 scope is an error; flag it.

---

## 2. Product Definition

**One sentence:** A native iOS app presenting a small, curated set of UI micro-interactions, each rendered live in SwiftUI, so that motion can be felt on a real device rather than watched as video.

**Core loop:** Open → scan the grid → tap something → feel it → replay it → optionally save it.

That loop is the whole product. Every requirement below either serves it or is decoration.

---

## 3. Product Principles

Decision rules for the inevitable moments when two options both seem reasonable. Listed in priority order — when they conflict, the higher one wins.

| # | Principle | In practice |
|---|-----------|-------------|
| P1 | **The motion is the content** | If a UI element competes with the animation for attention, remove the element |
| P2 | **Replayability over first impression** | Every animation must be re-triggerable without navigation. A motion you can only see once cannot be studied |
| P3 | **Stock iOS everywhere else** | System fonts, SF Symbols, semantic colours, standard navigation. No custom chrome |
| P4 | **Additive architecture** | Adding animation *n+1* must never require editing an existing animation's file |
| P5 | **Working over polished** | Ugly and functional ships before pretty and broken |

P4 is the load-bearing one. It is what makes this project survivable at a few hours a week.

---

## 4. Screen Inventory

Three screens, one empty state. Navigation is a standard two-tab `TabView`.

```
TabView
├── Tab 1: Library      (S1) ──tap──> Detail (S2)
└── Tab 2: Favourites   (S3) ──tap──> Detail (S2)
                              └── empty state (S3a)
```

### S1 — Library

The default screen on launch.

| Element | Specification |
|---------|---------------|
| Navigation title | "Library", large title style |
| Layout | 2-column grid, scrollable |
| Card | Rounded rectangle, ~4:3, containing an **SF Symbol** representing the interaction on a tinted panel, with title beneath and category label below that |
| Card state | Non-animating at rest — see BRD §6.2 |
| Favourite indicator | Small filled heart in the card corner when saved |
| Tap target | Whole card |

### S2 — Detail

Where the animation actually lives.

| Element | Specification |
|---------|---------------|
| Presentation | Pushed navigation, standard back button |
| Stage | The real, functioning control — a real toggle, a real heart, a real segmented pill — centred, occupying the upper ~60% of the screen with generous surrounding space |
| Resting state | Loads at rest. **Nothing plays automatically.** The person triggers the motion themselves by acting on the control the way they would in any app |
| Instruction | One short line beneath the stage naming the action, e.g. "Tap to toggle," "Swipe to delete," "Pull down to refresh" — replaces the old Replay button |
| Repeatability | Bidirectional controls (toggle, heart, segmented pill, play/pause) simply flip back and forth on each tap. One-directional controls (checkmark, delete, success states) reset themselves after a short pause or on next tap, so the motion can be felt again without leaving the screen |
| Favourite control | Heart in the navigation bar toolbar. Toggles immediately, no confirmation |
| Text block | Title, category, one-sentence description of what the motion communicates |
| Concept note | One line naming the SwiftUI mechanism behind it (e.g. "spring, response 0.4, damping 0.7") |

This replaces the project's original auto-play-plus-Replay-button design. Reasoning: auto-play turns the motion into something watched, which is exactly the flattened, video-like experience the BRD's problem statement (§2.1) identifies as the thing this app exists to avoid. Feeling a toggle means tapping the toggle, not watching a proxy play out beside it.

### S3 — Favourites

Identical grid component to S1, filtered to saved items only. No separate design work.

### S3a — Favourites empty state

| Element | Specification |
|---------|---------------|
| Icon | SF Symbol, heart outline, secondary colour |
| Message | "Nothing saved yet" |
| Sub-message | "Tap the heart on any motion to keep it here" |

---

## 5. Functional Requirements

### F1 — Browse the library

> As a designer, I want to see everything available at a glance, so I can pick what interests me without reading a list.

**Acceptance criteria**
- [ ] Grid displays all animations in the catalogue
- [ ] Grid scrolls smoothly with no visible stutter on device
- [ ] Each card shows title and category
- [ ] Favourited cards show a filled heart indicator
- [ ] Tapping a card opens the correct detail screen

### F2 — Trigger the motion yourself

> As a designer, I want to actually perform the action — tap the toggle, swipe the row — so I feel the motion the way a real user would, not watch it happen to something else.

**Acceptance criteria**
- [ ] Nothing animates automatically when the screen appears; it loads at rest
- [ ] The staged element is the real, functioning control, not a proxy or a video-like stand-in
- [ ] The instruction line correctly names the action the control expects
- [ ] Animation is legible at its staged size — not cramped
- [ ] Nothing else on screen moves while it plays

### F3 — Feel it repeatedly

> As a designer, I want to trigger the motion again and again, because timing takes several passes to actually read.

**Acceptance criteria**
- [ ] Bidirectional controls (toggle, heart, pill, play/pause) can be triggered back and forth indefinitely with no navigation required
- [ ] One-directional controls (checkmark, delete, success) reset themselves — after a short pause, or on the next tap — so the same motion can be re-triggered without leaving the screen
- [ ] Rapid repeated triggering does not leave the animation in a broken or half-finished state
- [ ] No navigation is required to re-trigger

### F4 — Save favourites

> As a designer, I want to keep the ones I'll actually use, so the app becomes a personal shortlist rather than a catalogue.

**Acceptance criteria**
- [ ] Heart control toggles saved state immediately on tap
- [ ] Control's appearance reflects current state unambiguously
- [ ] Saving from detail updates the indicator on the library card
- [ ] Un-saving removes the item from Favourites

### F5 — Favourites persist

> As a designer, I want my saved items to still be there tomorrow.

**Acceptance criteria**
- [ ] Saved items survive force-quit and relaunch
- [ ] **Test method:** force-quit via app switcher, reopen from home screen. Not by re-running from Xcode
- [ ] Empty state appears when nothing is saved
- [ ] No crash or hang on first launch, when no saved data exists

### F6 — Extensibility contract

Not user-facing, but a hard requirement — this is BRD P4 made concrete.

**Acceptance criteria**
- [ ] Each animation lives in its own file, containing only itself
- [ ] Each conforms to one shared, minimal interface: it can be displayed, and it can be told to replay
- [ ] Adding a new animation requires exactly two actions: create its file, add one entry to the catalogue list
- [ ] No existing animation file is edited when a new one is added
- [ ] Verified by adding animation #4 without opening files for #1–3

If this requirement is met, the project can survive a three-week gap. If it isn't, it probably won't.

### F7 — Filter by category, search by name or category

> As a designer, I want to jump straight to "Gesture" motions, or find "toggle" without scrolling, because six categories and sixteen-plus items is enough that browsing linearly starts to cost time.

**Acceptance criteria**
- [ ] A row of category filter chips (or equivalent) sits above the grid, derived from the distinct categories already present in `Motion.all` — never hardcoded, so a new category added later appears automatically
- [ ] Tapping a chip filters the grid to that category; tapping it again (or an "All" chip) clears the filter
- [ ] A native search field (`.searchable()`) filters the grid as the person types
- [ ] Search matches against **both** a motion's title and its category — typing "gesture" surfaces every Gesture-category motion, not just one named that
- [ ] Category filter and search compose — narrowing by category, then searching within it, works as expected
- [ ] Favourites tab gets the same filtering and search behaviour, applied to the already-favourited subset

---

## 6. Animation Shortlist

Ten micro-interactions, ordered by ascending build difficulty. Build in this order — competence compounds, and the early ones teach the concepts the later ones assume.

Ship at least eight (BRD success criterion 2). Items 9–10 are stretch.

| # | Name | What it demonstrates | Difficulty | Core mechanism |
|---|------|---------------------|------------|----------------|
| 1 | **Press scale** | The single most common feedback in mobile UI — how much scale-down feels responsive vs broken | Easiest | `scaleEffect` + spring |
| 2 | **Toggle switch** | Coordinated movement plus colour interpolation | Easy | `withAnimation`, offset, colour blend |
| 3 | **Like burst** | Overshoot — why settling past your target reads as satisfying | Easy | Spring with low damping, scale keyframes |
| 4 | **Drawn checkmark** | Sequencing: shape draws before it settles | Easy | `Path` + `trim` animation |
| 5 | **Icon morph** | Symbol transitions, play ↔ pause | Moderate | `contentTransition(.symbolEffect)` |
| 6 | **Sliding segment pill** | Shared-element movement — the single most reusable technique here | Moderate | `matchedGeometryEffect` |
| 7 | **Rolling counter** | Numeric change as motion rather than a jump cut | Moderate | `contentTransition(.numericText())` |
| 8 | **Progressive button** | Multi-stage state: idle → loading → success, with width change and label swap | Harder | State machine + transitions |
| 9 | **Radial reveal** | Motion originating from the touch point rather than the centre | Harder | Gesture location + mask/clip |
| 10 | **Staggered list reveal** | Cascade timing — why offsetting delays reads as intentional | Harder | Per-item animation delay |

Notes on the selection: items 1–4 are deliberately easy so you reach a working app quickly. Item 6 is the highest-value one to actually understand — shared-element movement underpins most sophisticated iOS motion. Items 9–10 are the first that involve real coordination, which is why they're last.

Substitutions are fine. Keep the ordering principle — easiest first.

### 6.1 Phase 2–4 shortlist (loading, gestures, transitions)

Confirmed as of the direct-manipulation retrofit (§5 F2/F3) and the haptics rule in `CLAUDE.md`. All eight items below trigger from a real interaction, same as the original ten — loading-category items use a "tap to simulate" trigger rather than auto-playing, since nothing in this app plays on its own.

| # | Name | Category | Trigger | Resets |
|---|------|----------|---------|--------|
| 11 | Skeleton shimmer | Loading | Tap "Simulate load" | Auto, after the shimmer completes |
| 12 | Spinner | Loading | Tap "Simulate load" | Auto, after a fixed duration |
| 13 | Progress bar fill | Loading | Tap "Simulate load" | Auto, once the bar reaches full |
| 14 | Swipe to delete | Gesture | Swipe the row | Row reappears on next trigger |
| 15 | Pull to refresh | Gesture | Pull down (`.refreshable`) | Naturally repeatable |
| 16 | Drag to reorder | Gesture | Long-press and drag (`.onMove`) | Naturally repeatable |
| 17 | Modal presentation | Transition | Tap to present | Dismiss and re-tap to repeat |
| 18 | Shared-element push | Transition | Tap the card (`matchedGeometryEffect`) | Naturally repeatable via back/forward |

Three new categories join "Feedback," "State change," and "Reveal": **Loading**, **Gesture**, **Transition** — same sentence-case convention.

---

## 7. Data Model

Deliberately minimal.

**Catalogue** — a hardcoded array in the app. No database, no remote fetch. Each entry holds: identifier, title, category, description, concept note, **SF Symbol name**, and a reference to its animation view.

**Favourites** — a set of identifiers, stored in `UserDefaults`.

On the storage choice: `SwiftData` would be the more impressive-sounding answer and is the wrong one here. Storing a set of strings needs no schema, no model container, and no migration story. Choosing the smaller tool for a small problem is a defensible engineering judgement, and it saves you two or three sessions of concepts you don't need yet. If you later want the exercise, converting this to SwiftData is a clean standalone project.

---

## 8. Non-Functional Requirements

| ID | Requirement | Notes |
|----|-------------|-------|
| N1 | Animations run without dropped frames on iPhone 16 | Test on device, not in Simulator |
| N2 | Grid scrolls smoothly with the full catalogue loaded | Static cards make this straightforward |
| N3 | Cold launch under ~2 seconds | Trivially met with no network calls |
| N4 | No network access whatsoever | Nothing to request, no permissions prompts |
| N5 | Portrait only, iPhone only | Set in project configuration |
| N6 | Light mode is the tested target | Dark mode is not a goal, but using semantic system colours means it will likely work incidentally. Don't spend sessions on it; don't deliberately break it either |
| N7 | No third-party packages | Per BRD R8 — keeps memory footprint and build times low on 8 GB |

---

## 9. Build Sequence

Each session is roughly 90 minutes. Each ends with something demonstrably better than it started — this is the mitigation for BRD R1, not an aspiration.

| Session | Goal | Done when |
|---------|------|-----------|
| 1 | Toolchain | GitHub repo created, cloned via Sourcetree, blank Xcode project runs on your iPhone, first commit pushed |
| 2 | Git habit | Three or four trivial commits made and pushed. Change a label, commit, push. Repeat. **No features** |
| 3 | Grid shell | Hardcoded catalogue of 3 placeholder items renders as a grid. Tapping pushes an empty detail screen |
| 4 | First motion | Animation #1 (press scale) plays on the detail screen |
| 5 | Replay | Replay button works, including rapid repeated taps (F3) |
| 6 | Favourites | Heart toggles, favourites tab filters correctly, empty state appears. In-memory only |
| 7 | Persistence | Favourites survive force-quit. **App is now functionally complete** |
| 8 | Contract test | Add animation #2 without touching animation #1's file. Proves F6 |
| 9+ | Content | One animation per session, roughly. Occasionally two for the easy ones |
| Final | Capture | Screen recording on device, README written, repo tidied |

**Session 7 is the real milestone.** From that point the app works end to end and everything after is additive. If life intervenes for a month, you return to a working app rather than a puzzle.

Sessions 1–2 contain no features on purpose. Learning Git while also debugging a feature is the collision described in BRD R3; separating them costs one session and prevents a lot of frustration.

---

## 10. Out of Scope

Per BRD §6.2, and repeated here because these are the ideas most likely to resurface mid-build: live-animating grid thumbnails, screen transitions, loading states, gesture-driven motion, in-app code snippets, numeric spec panels, dark mode work, iPad, landscape, accounts, backend, analytics, App Store submission. (Search and filtering were on this list originally; see F7 below — added once the catalogue's six categories made it worth the small cost.)

Each is deferred with a reason recorded in the BRD. If one starts to feel essential, revise the BRD rather than quietly expanding the build.

---

## 11. Open Decisions

1. ~~App name.~~ — **Resolved: Swatch.** Xcode project name will be `Swatch`, bundle identifier `com.<yourname>.swatch`
2. ~~Category labels.~~ — **Resolved:** "Feedback", "State change", "Reveal". Sentence case, per iOS convention
3. ~~Card poster treatment.~~ — **Resolved:** SF Symbol on a tinted panel. Chosen partly because it requires no asset production, which supports F6
4. **Stretch items.** Confirm whether #9 and #10 stay on the list or are cut now

---

*End of document. Next stage: screen mockups, rendered in chat for iteration.*

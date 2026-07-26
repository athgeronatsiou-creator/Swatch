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
7. **Haptic feedback on every interactive trigger.** Use SwiftUI's `.sensoryFeedback()` modifier bound to each control's own state change — never a manual `UIImpactFeedbackGenerator` call. Match the feedback type to what the motion represents rather than reusing the same one everywhere.

## Working style

- Explain what you changed and why, briefly, after any nontrivial edit — the person reviews every diff before accepting it and needs to actually understand it, not just approve it.
- Prefer small, focused changes over large multi-file rewrites. Sessions are ~90 minutes; changes should be reviewable in that window.
- When implementing an animation, match the spring/timing values already specified in that motion's entry in `Motion.swift` (the `concept` field) rather than inventing new ones — those values came from a spec, not from you.
- If a request would violate one of the hard rules above, say so and ask before proceeding, rather than working around it silently.

## Current state

Check `docs/PRD-motion-library-app.md` §9 (Build Sequence) for which session-numbered milestone is next. Update this file's "Current state" note as sessions complete, so future sessions don't need to be re-explained from scratch.

<!-- Update below as you progress -->
Last completed: Session 9+ — app is functionally complete end to end (Library grid, generic Detail shell, Favourites + empty state, two-tab TabView root). Favourites persistence verified via genuine force-quit + relaunch (F5). Contract test (F6) proven repeatedly. 8 of 8 minimum animations shipped: Press scale, Toggle switch, Like burst, Drawn checkmark, Icon morph, Sliding segment pill, Rolling counter, Progressive button. Custom accent color set (#6069CA, universal). Stretch items #9 (Radial reveal) and #10 (Staggered list reveal) remain optional — see PRD Open Decision #4.

Direct-manipulation retrofit done: Replay button and auto-play removed from DetailView; every animation now triggers from the real control (rule 6). Haptics added to all 8 original animations via `.sensoryFeedback()` (rule 7).

8 more animations added across 3 new categories — Loading (Skeleton shimmer, Spinner, Progress bar fill — tap "Simulate load", self-contained state machine), Gesture (Swipe to delete, Pull to refresh, Drag to reorder — real gestures, no tap surrogate), Transition (Modal presentation — sheet with custom content-reveal transition; Shared-element push — native `.navigationTransition(.zoom)` wired into LibraryView/FavouritesView only, no animation files touched). All 16 animations now have haptics. Full catalogue is 16/16 built; clean build succeeds.

Pull to refresh is fixed and verified working with a real pull gesture (counter reached "Refreshed 2×" in the Simulator). Two things were wrong, and both are worth knowing because they'll bite again:
1. A `List` given `.frame(height:) + .clipped()` is only *cropped* visually — the List still lays out at full height, so its content never overflows, vertical bouncing stays off, and `.refreshable` has no pull to engage. It needs to genuinely overflow its scroll view. Hence `PullToRefreshView`'s 10 rows are load-bearing, not decoration, and `DetailView` gives this one stage the spare height instead of the standard 220pt clipped box.
2. `.scrollDisabled` is not a way to stop an outer ScrollView competing for the drag — it sets an environment value that propagates down and disables the nested List too.
So `DetailView` now has one special case (`stageOwnsVerticalDrag`): pull to refresh renders with no enclosing ScrollView and an expanded stage. The other 15 animations still use the generic ScrollView + 220pt clipped-box path, re-checked after the change (Sliding segment pill still animates A→C correctly).

Known open item: Swipe to delete, Drag to reorder, and Modal presentation's sheet still need a manual on-device/Simulator gesture pass. Note for future sessions: scripted Simulator input in this project is usable but fiddly — pass coordinates in the **point** space the tool reports (402x874), not screenshot pixels, and remember async animations need a real wait before screenshotting or you'll misread a working feature as broken (that happened here). A stale attach session can also silently swallow all input; detach/reattach fixes it.

F7 (category filter + search) is done and verified in the Simulator on all three tabs. `MotionFiltering.swift` holds `CategoryFilterBar` plus the filter rules as extensions (`distinctCategories`, `matching(category:searchText:)`, `resolving(_:)`), so the three screens can't drift apart. Categories are derived from the item list, never hardcoded, so a new `Catalog` entry in a new category gets a chip for free. The chip row is a `.safeAreaInset(edge: .top)` on the grid, so it stays pinned while content scrolls beneath it. `MotionGrid.swift` is the shared two-column grid — it owns the zoom-transition `@Namespace` and the `navigationDestination`, which is why Library/Favourites/Search are each only a dozen lines.

Search is a third tab with `Tab(role: .search)`, not a field on each grid. That role is what makes iOS render it as a detached glass button at the trailing end of the tab bar and morph the bar into a search field on tap — it is the only native iOS 26 route to a tab-bar search button, and taking it means search is a destination rather than per-tab. `SearchView` therefore carries the chips *and* a `.searchScopes` All/Saved picker, which is what keeps F7's "filter composes with search" and "search inside the favourited subset" alive. Verified all three narrowing together: Saved + "gesture" + State change chip → correct empty state.

One pattern recurs and is worth remembering: any screen whose chips come from a subset can have the selected chip vanish underneath it — un-favourite the last Gesture motion, or flip the search scope to Saved. Hence `resolving(_:)` and the `Binding(get:set:)` in both `FavouritesView` and `SearchView`: a selection that no longer exists reads as All, so chips and grid never disagree. Verified by un-favouriting the last item of the selected category.

Known wart: `SearchView`'s scope and category selection persist after the search field is dismissed, but the scope bar only renders while search is active — so the tab can sit on Saved with no visible reason for the short list. Deliberately not fixed: resetting on dismissal needs `.searchable(text:isPresented:)`, and `isPresented` also goes false when pushing into a detail, so it would wipe the person's filters every time they came back from a motion.

Per-motion documentation, code snippets and sharing are done for all 16 motions. `MotionItem` gained two fields — `documentation` (long-form: how the motion is built and why) and `sourceSnippet` (the key SwiftUI logic as a plain string) — both populated inline in `Catalog.swift`, which keeps the F6 contract intact: adding a motion is still create-its-file plus one catalogue entry, just a longer entry. No animation file was edited. `DetailView` renders them as two collapsed `DisclosureGroup`s below the concept note, and the toolbar gained a native `ShareLink` (plain-text summary via `MotionItem.shareText`) to the left of the heart. The code block is deliberately plain: one monospaced `Text` in `.primary`, no highlighting, wrapped in a horizontal `ScrollView` because snippet lines are wider than the phone.

Note that `sourceSnippet` is a *copy* of code that lives elsewhere, so it can drift. If you change an animation's key logic, update its snippet in `Catalog.swift` too — nothing enforces this.

The pull-to-refresh special case needed extending, not replacing. Its screen still has no enclosing ScrollView, but the notes below the stage would have been unreachable once a section expanded, so they now sit in their own `ScrollView` capped at 320pt — a *sibling* of the stage rather than a parent of it, which is why it doesn't re-introduce the drag competition. Verified in the Simulator: two real pulls reached "Refreshed 2×" while the notes region scrolled independently to reach the Code section. Worth repeating the older warning, because it caught me again: the refreshed counter is the List's last row and sits below the fold, so a screenshot taken right after a pull looks like nothing happened.

One gap left open deliberately: the favourite heart in `DetailView`'s toolbar still has no `.sensoryFeedback()`, which is a rule 7 miss that predates this work. `ShareLink` has no state to bind a haptic to, so it has none by design.

Also worth knowing: this work was requested against "CLAUDE.md rules 9 and 10" and "PRD §5 F8 and F9", none of which exist — this file stops at rule 7 and the PRD at F7. The requirements came from the chat instead. If the docs are meant to be the record, F8 (documentation + code on the detail screen) and F9 (share) still need writing up.

Catalogue is now 24 motions. Eight added in one pass, each in its own file, no existing animation file touched: **Radial reveal** (PRD #9 — mask circle scaled from the touch point), **Staggered list reveal** (PRD #10 — per-index `.delay`), **Shake to reject** (Feedback — `keyframeAnimator`), **Hold to confirm** (Gesture — `onLongPressGesture` + `onPressingChanged`), **Pinch to zoom** (Gesture — `MagnifyGesture`), **Card flip** (Transition — `rotation3DEffect` + perspective), **Toast slide-in** (Transition — `.transition` on insertion), **Breathing pulse** (Loading — `autoreverses: true`). All use existing categories, so no new chips. Each has haptics, `documentation` and `sourceSnippet`, and triggers from its own control.

The spring/timing values for these eight are **not from a spec** — unlike the original ten, there was nothing in the PRD to match, so they were chosen during the build. Treat them as open to revision in a way the original values are not.

Three things learned that are worth keeping:
1. `Motion.swift` now holds one non-`Animation` constant (`staggerDelayStep`), because the gap between rows is a timing value like any other and belongs with them rather than buried in the view.
2. Card flip needs its face-swap animation **scoped to the faces**, not to the card. Two `.animation(_:value:)` modifiers stacked on the same container do not give you two curves — the outer wins, and the swap goes back to cross-fading in full view.
3. A resting state can be too empty. Staggered list reveal's rows are all at opacity 0 at rest, which is correct per F2 but left the stage completely blank with nothing to aim at, reading as broken. It now shows a "Tap to reveal" hint at rest, the same pattern radial reveal already uses.

Verification status, because it is uneven and the gaps matter:
- **Confirmed in the Simulator:** Card flip (back face lands unmirrored), Radial reveal (a corner tap still covers the whole panel, so the 2×diagonal diameter is right), Staggered list reveal (all four rows, plus the new hint), Toast slide-in (slides, clips, glass renders). Search still narrows correctly across 24 items.
- **Not captured:** Shake to reject, Hold to confirm's fill and confirmed states, Breathing pulse. All are shorter than the screenshot round-trip, so the capture always lands after they have reset. They compile and the resting states are correct, which is not the same as verified.
- **Not working under scripted input:** Pinch to zoom. `touch2_path` with a 4-second spread never moved the panel. That may be the tool rather than the code — `MagnifyGesture` is standard — but it is untested either way and needs a manual Option-drag in the Simulator or a real device before being trusted.

Next up if continuing: manual gesture pass on Pinch to zoom (highest priority — genuinely unverified), then Swipe to delete / Drag to reorder / Modal presentation, then the PRD's final step (screen recording, README, repo tidy). Also worth revisiting: with 24 motions the PRD's §6 shortlist tables are now well behind the actual catalogue.

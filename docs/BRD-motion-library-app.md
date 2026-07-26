# Business Requirements Document

**Project:** Swatch — iOS motion library app
**Name:** **Swatch** (confirmed)
**Version:** 0.1 — Draft for review
**Date:** 25 July 2026
**Author:** Athina
**Status:** Awaiting sign-off before PRD

---

## 1. Executive Summary

A native iOS application that presents a curated library of mobile UI animations, each rendered live in SwiftUI so that designers can experience the actual timing, easing and physics on a real device rather than judging motion from a looping GIF or a written spec.

The project has a dual purpose. As a product, it solves a real gap: motion is felt, not seen, and existing references (Dribbble, Pinterest, spec documents) flatten it into video. As a professional exercise, it serves as a portfolio piece demonstrating end-to-end ownership from requirements through design to a working, installable application.

---

## 2. Background & Problem Statement

### 2.1 The problem

Designers specify motion using vocabulary they have rarely experienced directly. Terms like *ease-out*, *spring*, *damping* and *300ms* are chosen from documentation rather than from felt experience. The consequences show up downstream:

- Animations that read well in a prototype feel sluggish or jittery on a device
- Specs handed to developers are ambiguous, producing rework
- Designers have no fast way to compare two easing curves side by side in a real context

Screen recordings do not solve this. Video playback is decoupled from touch, runs at a fixed frame rate, and cannot respond to the user's own gesture — which is precisely the part that determines whether motion feels right.

### 2.2 Why an app, not a reference site

The medium *is* the argument. Running natively means the animation responds to the user's finger, at the device's real refresh rate, with real spring physics. This is the single differentiator and it cannot be replicated in a browsable gallery.

---

## 3. Business Objectives

Because this is a personal project rather than a commercial product, "business" objectives are the author's professional objectives. They are listed in priority order.

| # | Objective | Why it matters |
|---|-----------|----------------|
| B1 | Ship a working app installed on a physical iPhone | Proves ability to finish, not just design |
| B2 | Build genuine literacy in SwiftUI animation | Directly improves day-to-day design work and developer handoff |
| B3 | Produce a demonstrable portfolio artefact | Evidence of end-to-end process: BRD → PRD → design → code |
| B4 | Learn a professional Git workflow | Transferable to any future collaboration with engineers |
| B5 | Create a personally useful motion reference | Sustains motivation once novelty fades |

**Explicit non-objectives:** revenue, user acquisition, App Store distribution, and scale. Any decision justified by "but what if lots of people use it" is out of scope by definition.

---

## 4. Success Criteria

The project is successful when all of the following are true:

1. The app launches and runs on the author's own iPhone without crashing
2. It contains **at least 8** distinct, working animations
3. Each animation can be replayed on demand without leaving the screen
4. Favourited animations persist across app launches (verified by force-quit and relaunch)
5. The GitHub repository shows a readable commit history with meaningful messages
6. The author can confidently modify any animation's parameters — timing, easing, spring damping — and predict the result before running it
7. A screen recording exists that is suitable for a portfolio or Dribbble post

Criterion 6 is deliberately scoped to *modification*, not authorship. The project is partly a demonstration of working efficiently with AI-assisted development; line-by-line authorship of the Swift is not the skill on display. What does need to be real is enough grounding to unstick yourself when generated code misbehaves and the first suggested fix doesn't work — which is the practical floor, not an academic one.

---

## 5. Stakeholders

| Stakeholder | Role | Interest |
|-------------|------|----------|
| Athina | Author, designer, developer, sole decision-maker | All objectives |
| Prospective employers / clients | Audience for the artefact | Evidence of craft and completion |
| Design peers | Informal reviewers | Quality of the motion itself |

No approval chain. This is an advantage: decisions can be made in minutes. It is also a risk, since nobody else will notice if the project stalls.

---

## 6. Scope

### 6.1 In scope — Version 1

| Item | Detail |
|------|--------|
| Content | 8–12 animations, **micro-interactions only** (buttons, toggles, likes, checkboxes, switches) |
| Browse screen | Grid of static poster cards, one per animation |
| Detail screen | Full-screen live animation with a replay control |
| Favourites | Mark/unmark an animation; persisted locally |
| Favourites view | Filtered list of saved animations |
| Metadata | Name, category, and short description per animation |
| Visual approach | Native iOS 26 **Liquid Glass** — translucent, blurred materials via SwiftUI's `.glassEffect()` / `GlassEffectContainer`, floating pill tab bar, glass circular toolbar buttons. Still stock iOS — this is the current system look, not a custom skin |
| Platform | iOS, iPhone only, portrait only |
| Distribution | Direct deployment from Xcode to the author's device |

### 6.2 Explicitly out of scope for Version 1

Deferred deliberately, with reasons, so these can be revisited rather than re-argued:

| Excluded | Reason |
|----------|--------|
| Live-animating grid thumbnails | Performance risk plus visual noise; needs design exploration first |
| Screen transitions & navigation animations | Each requires two complete screens; highest cost per animation |
| Loading & progress states | Phase 2 content |
| Gesture-driven animations | Phase 3 content; requires gesture-state handling |
| In-app SwiftUI code snippets | Author did not select this; adds a syntax-highlighting dependency |
| Numeric spec panel (duration, curve values) | Not selected; risks turning a feel-first app into a data sheet |
| ~~Search and filtering~~ | **Revised 26 Jul 2026:** added early, ahead of the original ~30-item threshold, once six categories made browsing worth speeding up. See PRD §5, F7 |
| Dark mode | Nice-to-have, not a success criterion |
| iPad, landscape, accessibility audit | Scope control |
| Accounts, backend, networking, analytics | No server component of any kind in v1 |
| App Store submission | Not an objective |

### 6.3 Content roadmap beyond v1

Ordered by ascending build difficulty, so competence compounds:

- **Phase 2** — Loading & progress states (skeletons, spinners, progress bars)
- **Phase 3** — Gesture-driven motion (swipe-to-delete, drag, pull-to-refresh)
- **Phase 4** — Screen transitions & navigation (shared-element transitions, modal presentation)
- **Phase 5** — Live thumbnails, side-by-side easing comparison, dark mode

---

## 7. Constraints

| ID | Constraint | Implication |
|----|------------|-------------|
| C1 | Author has minimal coding experience | Architecture must favour clarity over cleverness; no advanced patterns |
| C2 | A few hours per week, no deadline | Work must be decomposable into ~90-minute self-contained units |
| C3 | Solo project, no code reviewer | Code must be simple enough to be self-reviewable after a two-week gap |
| C4 | Free Apple ID provisioning expires after 7 days — **decision: accepted, no paid account** | App stops launching until redeployed from Xcode. Redeploy before showing the app to anyone. Do not confuse a redeploy with an app relaunch when testing persistence (see criterion 4) |
| C5 | Development machine: MacBook Pro, M3, **8 GB unified memory**, macOS Tahoe 26.5.1 | Confirmed. Xcode and SwiftUI Previews are memory-hungry; 8 GB is workable but tight. Prefer deploying to the physical iPhone over running the Simulator, and close Figma/browser during build sessions |
| C6 | Fixed toolchain: Xcode, Sourcetree, GitHub | Agreed; not open for revisiting mid-project |

---

## 8. Assumptions

| ID | Assumption | Risk if wrong |
|----|------------|---------------|
| A1 | ~~Author has access to a Mac~~ | **Resolved** — confirmed, see C5 |
| A2 | ~~Author has an iPhone running a recent iOS version~~ | **Resolved** — iPhone 16 on iOS 26.5; full current SwiftUI animation API surface available |
| A3 | SwiftUI's built-in animation system is sufficient; no third-party libraries needed | Added complexity and dependency management |
| A4 | All content is bundled in the app; no network access required | Would introduce backend scope |
| A5 | Author has a GitHub account, or can create one | Minor; easily resolved |

---

## 9. Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|-----------|--------|------------|
| R1 | **Momentum loss between sessions** — the primary risk, given no deadline | High | Fatal | Vertical-slice build: app fully works at 3 animations. Every session ends with something visibly better. Adding animation *n+1* must never require touching existing code |
| R2 | Scope creep — all four animation families were initially desired | High | High | v1 content locked to micro-interactions. Roadmap in §6.3 records ambition without expanding v1 |
| R3 | Two learning curves at once (Swift *and* Git) | High | Medium | Set up Git and make several trivial commits **before** writing any feature code, so version control is habit before it is load-bearing |
| R4 | Designer perfectionism — polishing visuals before the app functions end to end | Medium | High | Build ugly and working first. No visual refinement until all four v1 screens connect |
| R5 | Provisioning expiry mistaken for a broken app | Medium | Low | Documented in C4; a known, expected event |
| R6 | Generated code stops working and the author cannot diagnose it, stalling the build | Medium | Medium | Keep each animation in its own small file so faults are isolated; maintain a one-line plain-language note per animation describing what drives the motion; change one parameter at a time |
| R7 | Losing work — no backup, no version control discipline | Low | High | Push to GitHub at the end of every session, without exception |
| R8 | Memory pressure on 8 GB — SwiftUI Preview crashes and beachballing eroding short sessions | Medium | Medium | Build to the physical iPhone rather than the Simulator; keep only Xcode open while working; no third-party packages (dependency resolution adds load); restart Xcode when Previews stop refreshing rather than debugging them |

---

## 10. Open Questions

To be resolved before the PRD is finalised:

1. ~~Do you have a Mac, and which macOS version?~~ — **Resolved:** MacBook Pro M3, 8 GB, macOS Tahoe. Recorded as C5
2. ~~Which iPhone and iOS version?~~ — **Resolved:** iPhone 16, iOS 26.5
3. ~~Apple Developer account?~~ — **Resolved:** no paid account; 7-day redeploy cycle accepted (C4)
4. ~~Final app name?~~ — **Resolved:** Swatch
5. Which specific 8–12 micro-interactions? To be selected during the PRD
6. ~~Visual identity?~~ — **Resolved:** native iOS components throughout; optional branding pass deferred to a later phase

---

## 11. Approach & Sequencing

High-level only; detail belongs in the PRD.

| Stage | Output |
|-------|--------|
| 1 | **BRD** — this document, signed off |
| 2 | **PRD** — feature list, user stories, screen inventory, acceptance criteria, animation shortlist |
| 3 | **Design** — user flow plus screen mockups produced conversationally with Claude as rendered HTML, iterated in chat. **No Figma.** Motion itself is designed in stage 5, in SwiftUI Previews, because static tools cannot represent it |
| 4 | **Environment setup** — GitHub repository, Sourcetree, Xcode project, first commits |
| 5 | **Vertical slice** — grid → detail → one working animation, end to end |
| 6 | **Content build** — remaining animations, one self-contained unit at a time |
| 7 | **Favourites & persistence** |
| 8 | **Visual polish, device testing, portfolio recording** |

Stage 5 is the critical milestone. Once a single animation flows all the way through the app, the remainder is repetition rather than problem-solving — and repetition survives interruption.

Stage 3 is deliberately light. Because the app uses stock iOS components (§6.1), a high-fidelity design pass would largely consist of redrawing system defaults — effort spent producing a picture of something SwiftUI already gives you for free. Layout and hierarchy are settled with quick mockups; everything that actually matters visually is the motion, and that gets designed in code.

---

## 12. Interview Record

Answers on which this document is based:

- **Primary audience:** the author; a portfolio piece
- **Core user value:** browse and get inspired
- **v1 must contain:** previews plus save/favourite collections
- **Definition of done:** runs on the author's own iPhone
- **Time available:** a few hours per week, no deadline
- **Animation implementation:** coded natively in SwiftUI
- **Animation families desired:** all four (scoped down to one for v1)
- **Navigation model:** grid gallery (poster thumbnails in v1, live deferred)
- **Preferred working style:** guidance requested; recommendation recorded in §Approach

---

*End of document. Sign off or request revisions before the PRD is written.*

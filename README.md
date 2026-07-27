# Swatch

A native iOS app cataloguing UI micro-interactions — rendered live in SwiftUI, so the timing and feel can be experienced on a real device instead of watched as a flattened video.

![Swatch demo](Media/swatch-demo.gif)

[Full demo (46s, mp4)](Media/swatch-demo.mp4)

## Why this exists

Designers specify motion using words chosen from documentation — *ease-out*, *spring*, *300ms* — rather than words chosen from experience. That gap shows up downstream: animations that read well in a static prototype feel wrong on a device, and specs handed to developers end up ambiguous.

Swatch is an attempt at a better reference: a small library of real, interactive motion, felt by actually triggering it — tapping the toggle, swiping the row — rather than watching it autoplay.

## Features

- **Browse by category** — Feedback, State change, Reveal, Loading, Gesture, Transition
- **Search**, matching by name or category
- **Every motion is triggered directly**, not auto-played — you tap the toggle, swipe the row, pull to refresh, the same way you would in any real app
- **Haptic feedback** matched to what each motion represents
- **Favourites**, saved locally and persisted across launches
- **Documentation and source code** for every motion, shown in place
- **Share any motion** via the native iOS share sheet — send it in Messages, Mail, or copy it as text

## Built with

SwiftUI, entirely native — no third-party packages. Styled with iOS 26's Liquid Glass materials (`.glassEffect()`, `GlassEffectContainer`) and SF Symbols throughout.

That "no dependencies" choice was deliberate, not a limitation: it keeps the project buildable and maintainable on modest hardware (this was built on an 8GB M3 MacBook Pro), and it means every animation is genuinely just SwiftUI — nothing borrowed, nothing hidden behind a library.

## A note on process

This project was built from a full requirements process before any code existed — a BRD, then a PRD, both in [`docs/`](docs/) — followed by implementation with Claude Code, working from a project-level spec (`CLAUDE.md`) covering the app's architectural rules. Design iteration (screen layout, the app icon) happened conversationally with Claude before any of it touched Figma.

Worth reading if you want the reasoning behind a decision rather than just the decision — most choices in this app trace back to something written down in one of those two documents.

## Architecture note

Every animation lives in its own file and conforms to one shared interface. Adding a new one never requires editing an existing one — verified, during the build, by adding a new animation without opening any of the previous ones. This was the single rule most responsible for the project surviving being built a few hours a week, with real gaps in between sessions.

## Requirements

- Xcode 26+
- iOS 26+
- An Apple ID for on-device deployment (no paid developer account required to build and run)

## Running it

Clone the repo, open `Swatch.xcodeproj` in Xcode, select your device, and run. No configuration, no API keys, no setup beyond that — the app makes no network calls at all.

## Status

Actively in progress. Built solo, a few hours a week, as both a working reference tool and a demonstration of process — requirements through design through implementation.

---

Built by Athina Geronatsiou.

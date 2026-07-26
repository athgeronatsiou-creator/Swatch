//
//  Catalog.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import Foundation

enum Catalog {
    static let all: [MotionItem] = [
        MotionItem(
            id: "press-scale",
            title: "Press scale",
            category: "Feedback",
            symbolName: "hand.tap.fill",
            description: "Confirms the tap landed. Too much scale reads as broken.",
            conceptNote: "spring · response 0.35 · damping 0.7",
            documentation: """
                Every tap has to start from nothing, so play() sets scale to 0 outside any \
                animation block — an unanimated jump — and only then animates it back to 1. \
                Animate a single value from wherever it happens to be and the second tap \
                gives you a shrinking icon instead of a growing one.

                Damping 0.7 leaves just enough bounce to read as physical without wobbling, \
                and response 0.35 keeps the whole thing under half a second. That speed is \
                what makes it feel like a consequence of your finger rather than a separate \
                event.
                """,
            sourceSnippet: #"""
                @State private var scale = 1.0

                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.tint)
                    .scaleEffect(scale)
                    .onTapGesture { play() }
                    .sensoryFeedback(.impact(weight: .light), trigger: isPressed)

                private func play() {
                    isPressed.toggle()
                    scale = 0
                    withAnimation(Motion.pressScale) {
                        scale = 1
                    }
                }

                // Motion.swift
                static let pressScale = Animation.spring(response: 0.35, dampingFraction: 0.7)
                """#,
            kind: .pressScale
        ),
        MotionItem(
            id: "toggle-switch",
            title: "Toggle switch",
            category: "State change",
            symbolName: "switch.2",
            description: "Coordinated movement plus colour interpolation.",
            conceptNote: "easeInOut · duration 0.25",
            documentation: """
                Nothing here is offset by hand. The thumb's position comes from the ZStack's \
                alignment flipping between .leading and .trailing, and the track's colour \
                comes from the fill switching between green and systemGray4. Because both are \
                derived from the same isOn boolean, and that boolean changes inside \
                withAnimation, SwiftUI interpolates the alignment and the colour together on \
                one timeline.

                easeInOut over 0.25s is deliberately not a spring. A switch is a mechanical \
                object with two settled positions, and a spring's overshoot would suggest it \
                could come to rest somewhere in between.
                """,
            sourceSnippet: #"""
                @State private var isOn = false

                ZStack(alignment: isOn ? .trailing : .leading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isOn ? Color.green : Color(.systemGray4))
                        .frame(width: 51, height: 31)

                    Circle()
                        .fill(.white)
                        .padding(2)
                        .shadow(radius: 1)
                }
                .frame(width: 51, height: 31)
                .onTapGesture { play() }
                .sensoryFeedback(.impact(weight: .light), trigger: isOn)

                private func play() {
                    withAnimation(Motion.toggleSwitch) {
                        isOn.toggle()
                    }
                }

                // Motion.swift
                static let toggleSwitch = Animation.easeInOut(duration: 0.25)
                """#,
            kind: .toggleSwitch
        ),
        MotionItem(
            id: "like-burst",
            title: "Like burst",
            category: "Feedback",
            symbolName: "heart.fill",
            description: "Settling past the target reads as more satisfying than landing on it exactly.",
            conceptNote: "spring · response 0.4 · damping 0.4",
            documentation: """
                The overshoot is the whole point, and it comes from the damping fraction \
                rather than from extra keyframes. At 0.4 the spring is under-damped, so the \
                heart travels past its target scale, comes back, and settles — one gesture, \
                three visual beats, no timeline to author.

                Scale and colour are both read off isLiked, so filling and growing happen on \
                the same spring. The unselected state sits at 0.8 rather than 1.0 so there is \
                somewhere to travel from; a heart that only changed colour would land \
                correctly and feel like nothing happened.
                """,
            sourceSnippet: #"""
                @State private var isLiked = false

                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 60))
                    .foregroundStyle(isLiked ? .red : .secondary)
                    .scaleEffect(isLiked ? 1 : 0.8)
                    .onTapGesture { play() }
                    .sensoryFeedback(trigger: isLiked) { _, newValue in
                        newValue ? .success : .impact(weight: .light)
                    }

                private func play() {
                    withAnimation(Motion.likeBurst) {
                        isLiked.toggle()
                    }
                }

                // Motion.swift
                static let likeBurst = Animation.spring(response: 0.4, dampingFraction: 0.4)
                """#,
            kind: .likeBurst
        ),
        MotionItem(
            id: "drawn-checkmark",
            title: "Drawn checkmark",
            category: "Reveal",
            symbolName: "checkmark.circle.fill",
            description: "The shape draws in before it settles, instead of just appearing.",
            conceptNote: "Path · trim · easeOut 0.4",
            documentation: """
                A checkmark that appears is information; one that draws is an event. The mark \
                is a two-line Path in a custom Shape, and .trim(from: 0, to: trimEnd) renders \
                only the first trimEnd fraction of it. Animating trimEnd from 0 to 1 walks \
                the stroke along the path. A grey copy of the same shape sits underneath, so \
                the stroke reads as a track being filled rather than a line appearing in \
                empty space.

                Two curves run in sequence rather than together: easeOut 0.4 for the draw, \
                then a spring in the completion handler that snaps scale from 1.2 back to 1. \
                That settle pulse is what makes the mark feel like it arrived rather than \
                merely finished. The guard on trimEnd == 0 stops a rapid second tap \
                restarting the draw halfway through.
                """,
            sourceSnippet: #"""
                private struct CheckmarkShape: Shape {
                    func path(in rect: CGRect) -> Path {
                        var path = Path()
                        path.move(to: CGPoint(x: rect.minX + rect.width * 0.18, y: rect.minY + rect.height * 0.55))
                        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.42, y: rect.minY + rect.height * 0.78))
                        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.85, y: rect.minY + rect.height * 0.25))
                        return path
                    }
                }

                @State private var trimEnd = 0.0
                @State private var scale = 1.0

                ZStack {
                    CheckmarkShape()
                        .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round))

                    CheckmarkShape()
                        .trim(from: 0, to: trimEnd)
                        .stroke(.tint, style: StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round))
                }

                private func play() {
                    guard trimEnd == 0 else { return }
                    withAnimation(Motion.checkmarkDraw) {
                        trimEnd = 1
                    } completion: {
                        scale = 1.2
                        withAnimation(Motion.checkmarkSettle) {
                            scale = 1
                        }
                    }
                }

                // Motion.swift
                static let checkmarkDraw = Animation.easeOut(duration: 0.4)
                static let checkmarkSettle = Animation.spring(response: 0.3, dampingFraction: 0.5)
                """#,
            kind: .drawnCheckmark
        ),
        MotionItem(
            id: "icon-morph",
            title: "Icon morph",
            category: "State change",
            symbolName: "playpause.fill",
            description: "The symbol morphs into its next state instead of swapping instantly.",
            conceptNote: "contentTransition · symbolEffect(.replace)",
            documentation: """
                One modifier does the work: .contentTransition(.symbolEffect(.replace)). Both \
                states are the same Image view with a different systemName, so SwiftUI treats \
                it as one view whose content changed rather than two views swapping. SF \
                Symbols then interpolates between the glyphs — the play triangle collapses as \
                the pause bars grow out of it.

                This only works because both are system symbols, which share internal \
                geometry that Apple has already matched up. A pair of custom image assets \
                would cross-fade at best. easeInOut 0.3 is short enough that you read one \
                shape changing rather than two shapes trading places.
                """,
            sourceSnippet: #"""
                @State private var isPlaying = false

                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.tint)
                    .contentTransition(.symbolEffect(.replace))
                    .onTapGesture { play() }
                    .sensoryFeedback(.impact(weight: .light), trigger: isPlaying)

                private func play() {
                    withAnimation(Motion.iconMorph) {
                        isPlaying.toggle()
                    }
                }

                // Motion.swift
                static let iconMorph = Animation.easeInOut(duration: 0.3)
                """#,
            kind: .iconMorph
        ),
        MotionItem(
            id: "sliding-segment-pill",
            title: "Sliding segment pill",
            category: "State change",
            symbolName: "capsule.fill",
            description: "The selection indicator slides to its new position rather than jumping.",
            conceptNote: "matchedGeometryEffect · spring 0.35 · 0.75",
            documentation: """
                There is only ever one pill in the view tree. The Capsule is drawn in the \
                background of whichever segment is currently selected, so tapping a new \
                segment technically destroys one capsule and creates another somewhere else. \
                matchedGeometryEffect, with the same id in the same namespace, tells SwiftUI \
                those two are the same element — so instead of fading one out and another in, \
                it animates the frame from the old position to the new one.

                The shared @Namespace and the identical id string are the entire mechanism; \
                lose either and it reverts to a cross-fade. Spring 0.35 / 0.75 is only just \
                under-damped: enough follow-through to read as momentum, not enough to look \
                loose on a control this small.
                """,
            sourceSnippet: #"""
                @State private var selection = 0
                @Namespace private var namespace

                private let segments = ["A", "B", "C"]

                HStack(spacing: 4) {
                    ForEach(segments.indices, id: \.self) { index in
                        Text(segments[index])
                            .foregroundStyle(selection == index ? .white : .primary)
                            .frame(width: 44, height: 36)
                            .background {
                                if selection == index {
                                    Capsule()
                                        .fill(.tint)
                                        .matchedGeometryEffect(id: "pill", in: namespace)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { select(index) }
                    }
                }
                .padding(4)
                .background(Color(.systemGray5), in: Capsule())
                .sensoryFeedback(.selection, trigger: selection)

                private func select(_ index: Int) {
                    withAnimation(Motion.segmentSlide) {
                        selection = index
                    }
                }

                // Motion.swift
                static let segmentSlide = Animation.spring(response: 0.35, dampingFraction: 0.75)
                """#,
            kind: .slidingSegmentPill
        ),
        MotionItem(
            id: "rolling-counter",
            title: "Rolling counter",
            category: "State change",
            symbolName: "textformat.123",
            description: "The value rolls through the numbers in between, instead of cutting straight to the new one.",
            conceptNote: "contentTransition · numericText",
            documentation: """
                .contentTransition(.numericText()) turns a Text whose string changed into a \
                digit-by-digit roll: each character column slides vertically to its new \
                glyph, and columns that didn't change stay put. The rounded system font at a \
                fixed weight matters here — it keeps digit widths stable, so the columns \
                don't reflow sideways while they are rolling.

                Spring 0.45 / 0.8 is slower and better damped than the feedback springs in \
                this catalogue, because you are meant to read the number as it lands rather \
                than just register that something moved. The increment is random, so repeated \
                taps roll different distances and you can watch how the same curve handles \
                one digit rolling versus two.
                """,
            sourceSnippet: #"""
                @State private var count = 0

                Text("\(count)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundStyle(.tint)
                    .contentTransition(.numericText())
                    .onTapGesture { play() }
                    .sensoryFeedback(.selection, trigger: count)

                private func play() {
                    withAnimation(Motion.counterRoll) {
                        count += Int.random(in: 3...9)
                    }
                }

                // Motion.swift
                static let counterRoll = Animation.spring(response: 0.45, dampingFraction: 0.8)
                """#,
            kind: .rollingCounter
        ),
        MotionItem(
            id: "progressive-button",
            title: "Progressive button",
            category: "Feedback",
            symbolName: "paperplane.fill",
            description: "One control carries the whole journey: idle, loading, then success.",
            conceptNote: "state machine · idle → loading → success",
            documentation: """
                One control, three states, held in a small private enum. Every visual \
                property is derived from that state — the label, the width from the computed \
                width property, the background colour — so a single withAnimation around the \
                state change morphs all of them on one timeline. Because the shape is a \
                Capsule, the width change reads as the button breathing rather than being \
                resized.

                play() runs the sequence in a Task with explicit sleeps, which is exactly \
                where a real network call would go. The guard on the idle state makes the \
                button inert while work is in flight — the same protection a real submit \
                needs, not a demo convenience. Returning to idle after the success beat is \
                what lets you trigger it repeatedly without leaving the screen.
                """,
            sourceSnippet: #"""
                private enum ButtonStage {
                    case idle, loading, success
                }

                @State private var stage: ButtonStage = .idle

                Group {
                    switch stage {
                    case .idle:
                        Text("Submit")
                    case .loading:
                        ProgressView()
                            .tint(.white)
                    case .success:
                        Label("Done", systemImage: "checkmark")
                    }
                }
                .frame(width: width, height: 44)
                .background(stage == .success ? Color.green : Color.accentColor, in: Capsule())
                .onTapGesture { play() }

                private var width: CGFloat {
                    switch stage {
                    case .idle: 120
                    case .loading: 60
                    case .success: 110
                    }
                }

                private func play() {
                    guard stage == .idle else { return }
                    Task {
                        withAnimation(Motion.progressiveButton) {
                            stage = .loading
                        }
                        try? await Task.sleep(for: .milliseconds(900))
                        withAnimation(Motion.progressiveButton) {
                            stage = .success
                        }
                        try? await Task.sleep(for: .milliseconds(900))
                        withAnimation(Motion.progressiveButton) {
                            stage = .idle
                        }
                    }
                }

                // Motion.swift
                static let progressiveButton = Animation.spring(response: 0.4, dampingFraction: 0.75)
                """#,
            kind: .progressiveButton
        ),
        MotionItem(
            id: "skeleton-shimmer",
            title: "Skeleton shimmer",
            category: "Loading",
            symbolName: "rectangle.dashed",
            description: "A placeholder that moves reads as 'still working' — a static one reads as broken.",
            conceptNote: "gradient sweep · linear 1.1s · repeatForever",
            documentation: """
                The placeholder itself is an ordinary grey rounded rectangle. The shimmer is a \
                three-stop LinearGradient — clear, translucent white, clear — 120pt wide, \
                sitting in an .overlay and moved across by animating its x offset from -160 \
                to 160. The .clipShape on the outside is what keeps the highlight from \
                spilling past the placeholder's corners.

                Both animation choices are deliberate. The curve is linear because an easing \
                curve makes the sweep appear to hesitate at each edge, which reads as \
                stalling rather than working. And autoreverses is false because a highlight \
                travelling backwards reads as scrubbing, not progress — so each pass restarts \
                from the left instead.
                """,
            sourceSnippet: #"""
                @State private var sweepOffset: CGFloat = -160

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .frame(width: 200, height: 100)
                    .overlay {
                        LinearGradient(
                            colors: [.clear, Color.white.opacity(0.7), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 120)
                        .offset(x: sweepOffset)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                // in play()
                sweepOffset = -160
                withAnimation(Motion.shimmerSweep) {
                    sweepOffset = 160
                }

                // Motion.swift
                static let shimmerSweep = Animation.linear(duration: 1.1).repeatForever(autoreverses: false)
                """#,
            kind: .skeletonShimmer
        ),
        MotionItem(
            id: "spinner",
            title: "Spinner",
            category: "Loading",
            symbolName: "arrow.clockwise",
            description: "No progress to report yet, so the motion itself is the only signal that something is happening.",
            conceptNote: "rotationEffect · linear 0.9s · repeatForever",
            documentation: """
                The arc is a Circle trimmed to 0.75 — three quarters of the ring — stroked \
                with a round line cap so its ends read as a deliberate shape rather than a \
                broken circle. The rotation is a single animated Double driving \
                .rotationEffect, which is all a spinner needs.

                linear plus repeatForever(autoreverses: false) is the part that matters. Any \
                easing curve creates a visible slow-down once per revolution, and because a \
                rotating arc has no fixed reference point, that slow-down reads as stuttering \
                rather than as rhythm. 0.9s per turn is fast enough to look busy and slow \
                enough not to strobe.
                """,
            sourceSnippet: #"""
                @State private var rotation: Double = 0

                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(.tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotation))

                // in play()
                rotation = 0
                withAnimation(Motion.spinnerRotate) {
                    rotation = 360
                }

                // Motion.swift
                static let spinnerRotate = Animation.linear(duration: 0.9).repeatForever(autoreverses: false)
                """#,
            kind: .spinner
        ),
        MotionItem(
            id: "progress-bar-fill",
            title: "Progress bar fill",
            category: "Loading",
            symbolName: "gauge",
            description: "Once you can report real progress, showing it beats a generic spinner every time.",
            conceptNote: "width animation · easeInOut 1.4s",
            documentation: """
                A grey Capsule track with a tinted Capsule in an .overlay pinned to .leading, \
                and the only animated value is that inner capsule's width going from 0 to the \
                track's full 200pt. The .leading alignment is what makes it grow from the left \
                edge rather than expanding out from the centre.

                easeInOut 1.4 rather than a spring, because a spring overshoots and \
                overshooting past 100% is meaningless for progress. The duration is matched to \
                the simulated load, so the bar reaches full at the moment the work actually \
                finishes — a bar that fills fast and then sits at 100% waiting is worse than \
                no bar at all, because it looks like the app has hung.
                """,
            sourceSnippet: #"""
                @State private var fillWidth: CGFloat = 0

                private let trackWidth: CGFloat = 200

                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(width: trackWidth, height: 12)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(.tint)
                            .frame(width: fillWidth, height: 12)
                    }

                // in play()
                fillWidth = 0
                withAnimation(Motion.progressBarFill) {
                    fillWidth = trackWidth
                }

                // Motion.swift
                static let progressBarFill = Animation.easeInOut(duration: 1.4)
                """#,
            kind: .progressBarFill
        ),
        MotionItem(
            id: "swipe-to-delete",
            title: "Swipe to delete",
            category: "Gesture",
            symbolName: "trash.fill",
            description: "The reveal has to track your finger exactly, or the gesture stops feeling direct.",
            conceptNote: "DragGesture · translation-driven offset",
            documentation: """
                Two different jobs here, and they need to be written differently. While your \
                finger is down, .onChanged assigns offset straight from \
                value.translation.width with no animation at all — that is what makes the \
                reveal track your finger exactly. Wrapping this in withAnimation puts the row \
                permanently a few frames behind your thumb, and the gesture immediately stops \
                feeling direct. The max(min(...)) pair clamps travel so the row can't be \
                dragged past the affordance behind it.

                Animation only appears on release. .onEnded compares offset against the -80pt \
                threshold and either springs it back to 0 or hands off to commitDelete(), \
                which eases the row out over 0.25s. The separate isPastThreshold boolean \
                exists only so the haptic can fire at the moment the threshold is crossed — \
                you feel the commitment point before you lift your finger, which is what \
                makes the delete feel decidable rather than accidental.
                """,
            sourceSnippet: #"""
                private let deleteThreshold: CGFloat = -80
                private let maxDrag: CGFloat = -140

                @State private var offset: CGFloat = 0
                @State private var isPastThreshold = false

                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard !isDeleting else { return }
                            offset = max(min(value.translation.width, 0), maxDrag)
                            isPastThreshold = offset < deleteThreshold
                        }
                        .onEnded { _ in
                            guard !isDeleting else { return }
                            if offset < deleteThreshold {
                                commitDelete()
                            } else {
                                withAnimation(Motion.swipeSnap) {
                                    offset = 0
                                }
                            }
                        }
                )
                .sensoryFeedback(.impact(weight: .medium), trigger: isPastThreshold)

                private func commitDelete() {
                    withAnimation(Motion.swipeRemove) {
                        offset = -rowWidth
                        isDeleting = true
                    }
                }

                // Motion.swift
                static let swipeSnap = Animation.spring(response: 0.35, dampingFraction: 0.8)
                static let swipeRemove = Animation.easeIn(duration: 0.25)
                """#,
            kind: .swipeToDelete
        ),
        MotionItem(
            id: "pull-to-refresh",
            title: "Pull to refresh",
            category: "Gesture",
            symbolName: "arrow.down.circle",
            description: "Built into List and ScrollView — the whole interaction ships for one modifier.",
            conceptNote: "refreshable · system-driven",
            documentation: """
                .refreshable is essentially the entire interaction. The arrow, the \
                rubber-banding, the spinner and the retraction are all system-owned. What it \
                wants from you is an async closure, and the indicator stays up until that \
                closure returns — which is the only reason the simulated 1.2s sleep is there.

                The part that isn't obvious is the demand it makes on layout. .refreshable \
                only engages if its scroll view can genuinely overscroll, so the List's \
                content has to exceed its frame. The ten rows are load-bearing, not filler. \
                It is also why this one motion gets a taller stage on the detail screen with \
                no enclosing ScrollView: a parent ScrollView competes for the same vertical \
                drag, and .scrollDisabled is no help because it propagates down the hierarchy \
                and switches the List's own scrolling off too.

                The only animation written by hand is the counter's .numericText transition, \
                which is there to prove the refresh actually completed.
                """,
            sourceSnippet: #"""
                @State private var refreshCount = 0

                List {
                    // Enough rows to overflow the stage. A List whose content fits inside its
                    // frame switches vertical bouncing off, and `.refreshable` has no pull to
                    // hook into — so the row count is load-bearing here, not decoration.
                    ForEach(0..<10, id: \.self) { index in
                        Label("Item \(index + 1)", systemImage: "doc.text")
                    }

                    Text(refreshCount == 0 ? "Pull down to refresh" : "Refreshed \(refreshCount)×")
                        .contentTransition(.numericText())
                        .animation(Motion.refreshContentUpdate, value: refreshCount)
                }
                .listStyle(.plain)
                .refreshable {
                    try? await Task.sleep(for: .milliseconds(1200))
                    refreshCount += 1
                }
                .sensoryFeedback(.success, trigger: refreshCount)

                // Motion.swift
                static let refreshContentUpdate = Animation.easeOut(duration: 0.3)
                """#,
            kind: .pullToRefresh
        ),
        MotionItem(
            id: "drag-to-reorder",
            title: "Drag to reorder",
            category: "Gesture",
            symbolName: "line.3.horizontal",
            description: "The list makes room before you let go, not after.",
            conceptNote: "onMove · List edit mode",
            documentation: """
                There is no animation code in this one at all, and that is the lesson. \
                .onMove(perform:) on the ForEach, plus an active edit mode, buys you the \
                entire interaction: the lift, the shadow under the raised row, the gap opening \
                beneath it, the other rows sliding to make space, and the settle on drop. The \
                move handler itself is not animation code — it only reorders the array, after \
                the fact.

                Watch the ordering, because it is the reason the system version feels good: \
                the list makes room while your finger is still down, so you can see the \
                outcome before you commit to it. The editMode environment value is pinned to \
                active here to keep the drag handles permanently visible on the stage; in a \
                real list you would bind that to an Edit button instead.
                """,
            sourceSnippet: #"""
                @State private var items = ["Frame", "Shadow", "Blur", "Glow"]

                List {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                    .onMove(perform: move)
                }
                .listStyle(.plain)
                .environment(\.editMode, .constant(.active))
                .sensoryFeedback(.selection, trigger: items)

                private func move(from source: IndexSet, to destination: Int) {
                    items.move(fromOffsets: source, toOffset: destination)
                }

                // No Motion.swift entry — the reorder animation belongs to List.
                """#,
            kind: .dragToReorder
        ),
        MotionItem(
            id: "modal-presentation",
            title: "Modal presentation",
            category: "Transition",
            symbolName: "square.on.square",
            description: "A sheet says 'this is temporary, dismiss whenever' just by how it arrives.",
            conceptNote: "sheet · content transition on appear",
            documentation: """
                The sheet is one modifier, and iOS owns its arrival entirely — the slide up, \
                the settle, the dimming of the screen behind, the drag-to-dismiss. \
                .presentationDetents([.medium]) is what stops it reaching full height, and \
                that height cap is most of what makes it read as temporary rather than as a \
                new screen you have navigated to.

                What is added by hand is a second beat inside the sheet. ModalContent starts \
                at 0.85 scale and zero opacity and animates both to rest in .onAppear, so the \
                content arrives just after the container instead of riding up with it. Damping \
                0.8 is high because this is a settle, not a bounce.

                Splitting the two beats is the technique worth stealing: let the system move \
                the surface, and move what's on it yourself, slightly late.
                """,
            sourceSnippet: #"""
                @State private var isPresented = false

                Button {
                    isPresented = true
                } label: {
                    Label("Show details", systemImage: "square.on.square")
                }
                .glassEffect()
                .sheet(isPresented: $isPresented) {
                    ModalContent()
                        .presentationDetents([.medium])
                        .presentationCornerRadius(32)
                }
                .sensoryFeedback(trigger: isPresented) { _, newValue in
                    newValue ? .impact(weight: .light) : nil
                }

                private struct ModalContent: View {
                    @Environment(\.dismiss) private var dismiss
                    @State private var isVisible = false

                    var body: some View {
                        VStack(spacing: 16) {
                            Image(systemName: "square.on.square")
                            Text("A modal, presented")
                            Button("Dismiss") { dismiss() }
                        }
                        .padding(32)
                        .scaleEffect(isVisible ? 1 : 0.85)
                        .opacity(isVisible ? 1 : 0)
                        .onAppear {
                            withAnimation(Motion.modalContentReveal) {
                                isVisible = true
                            }
                        }
                    }
                }

                // Motion.swift
                static let modalContentReveal = Animation.spring(response: 0.4, dampingFraction: 0.8)
                """#,
            kind: .modalPresentation
        ),
        MotionItem(
            id: "shared-element-push",
            title: "Shared-element push",
            category: "Transition",
            symbolName: "arrow.up.left.and.arrow.down.right",
            description: "The card doesn't disappear and get replaced by the next screen — it grows into it.",
            conceptNote: "navigationTransition(.zoom) · shared namespace",
            documentation: """
                None of this lives in the animation's own file, and it can't: a \
                shared-element transition is by definition a relationship between two \
                screens. It is wired in MotionGrid.swift, which is the one place that owns \
                the @Namespace both ends need.

                Two halves have to agree. .matchedTransitionSource(id:in:) marks the grid card \
                as the thing being zoomed from; .navigationTransition(.zoom(sourceID:in:)) on \
                the destination marks the detail screen as the thing being zoomed into. \
                Matching ids in a shared namespace are the whole connection. iOS then \
                interpolates the card's frame into the pushed screen's frame, and runs it in \
                reverse on the way back — including if you interrupt the back-swipe halfway \
                and let go.

                The rectangle staged on this screen is only something to look at. The motion \
                you are inspecting is the push you already performed to get here, which is \
                why the instruction asks you to go back and watch it happen in reverse.
                """,
            sourceSnippet: #"""
                // MotionGrid.swift — not SharedElementPushView.swift. The grid owns the
                // namespace, because both ends of the transition have to share one.
                @Namespace private var zoomNamespace

                ForEach(items) { item in
                    NavigationLink(value: item) {
                        MotionCardView(item: item, isFavorite: favorites.contains(item.id))
                    }
                    .buttonStyle(.plain)
                    .matchedTransitionSource(id: item.id, in: zoomNamespace)
                }

                .navigationDestination(for: MotionItem.self) { item in
                    if item.kind == .sharedElementPush {
                        DetailView(item: item)
                            .navigationTransition(.zoom(sourceID: item.id, in: zoomNamespace))
                    } else {
                        DetailView(item: item)
                    }
                }

                // No Motion.swift entry — iOS owns the curve for a zoom transition.
                """#,
            kind: .sharedElementPush
        ),
        MotionItem(
            id: "radial-reveal",
            title: "Radial reveal",
            category: "Reveal",
            symbolName: "circle.circle",
            description: "Starting the motion where the finger landed makes the app feel like it's responding to you, not just to the tap.",
            conceptNote: "mask · circle scale from touch point · easeOut 0.45",
            documentation: """
                The revealed layer never moves. What animates is the hole it is seen \
                through: a Circle in a .mask, centred on the touch point and scaled from 0 \
                to 1. Because the circle is scaled rather than resized, its growth is \
                cheap and stays perfectly round.

                Two values are set outside the animation block — the origin and the scale \
                reset. That matters: if origin is assigned inside withAnimation, the opening \
                slides over from the last place you tapped instead of starting where your \
                finger just was, which is precisely the effect this motion exists to \
                demonstrate. The circle's diameter is twice the panel's diagonal so that a \
                tap in a corner still reaches the opposite one.

                easeOut 0.45 because a reveal should leave fast and arrive gently — the \
                opposite bias to a button press.
                """,
            sourceSnippet: #"""
                @State private var origin: CGPoint = .zero
                @State private var revealScale: CGFloat = 0

                // Big enough that a circle centred in any corner still reaches the far one.
                private var diameter: CGFloat {
                    2 * hypot(panel.width, panel.height)
                }

                RoundedRectangle(cornerRadius: 16)
                    .fill(.tint)
                    .mask(alignment: .topLeading) {
                        Circle()
                            .frame(width: diameter, height: diameter)
                            .scaleEffect(revealScale)
                            .offset(x: origin.x - diameter / 2, y: origin.y - diameter / 2)
                    }

                .onTapGesture(coordinateSpace: .local) { location in
                    reveal(from: location)
                }

                private func reveal(from location: CGPoint) {
                    guard !isRevealed else { return }

                    // Outside the animation: the circle has to jump to the new touch
                    // point, not slide there from the last one.
                    origin = location
                    revealScale = 0
                    isRevealed = true

                    withAnimation(Motion.radialReveal) {
                        revealScale = 1
                    }
                }

                // Motion.swift
                static let radialReveal = Animation.easeOut(duration: 0.45)
                """#,
            kind: .radialReveal
        ),
        MotionItem(
            id: "staggered-list-reveal",
            title: "Staggered list reveal",
            category: "Reveal",
            symbolName: "list.bullet.indent",
            description: "Offsetting each row by a few frames reads as deliberate. Firing them together reads as a jump cut.",
            conceptNote: "per-index delay · 0.06s step · spring 0.4 · 0.8",
            documentation: """
                There is one piece of state — a single boolean — and every row watches it. \
                The cascade comes entirely from .delay(Double(index) * step) on each row's \
                animation, so row 0 starts immediately, row 1 six hundredths later, and so \
                on. Nothing tracks which rows have finished, and no timers are involved.

                The step size is the whole design decision. Too small and the rows read as \
                arriving together; too large — past roughly 0.1s per row — and the list \
                reads as slow rather than as cascading, because the eye starts waiting for \
                the next one. 0.06 is short enough to feel like one gesture with internal \
                structure.

                Each row also travels 14pt as it fades, because opacity alone reads as \
                material appearing while a small offset reads as material arriving. Tapping \
                again reverses the whole thing on the same delays, so the first row in is \
                also the first row out.
                """,
            sourceSnippet: #"""
                @State private var isRevealed = false

                VStack(spacing: 8) {
                    ForEach(rows.indices, id: \.self) { index in
                        row(index)
                            .opacity(isRevealed ? 1 : 0)
                            .offset(y: isRevealed ? 0 : 14)
                            // One state change, four different start times.
                            .animation(
                                Motion.staggerRow.delay(Double(index) * Motion.staggerDelayStep),
                                value: isRevealed
                            )
                    }
                }
                .onTapGesture { isRevealed.toggle() }
                .sensoryFeedback(.impact(weight: .light), trigger: isRevealed)

                // Motion.swift
                static let staggerRow = Animation.spring(response: 0.4, dampingFraction: 0.8)
                static let staggerDelayStep = 0.06
                """#,
            kind: .staggeredListReveal
        ),
        MotionItem(
            id: "shake-to-reject",
            title: "Shake to reject",
            category: "Feedback",
            symbolName: "exclamationmark.triangle.fill",
            description: "A refusal has to feel like the interface saying no, which means it can't be smooth.",
            conceptNote: "keyframeAnimator · 6 legs · decaying amplitude",
            documentation: """
                This is the one motion in the catalogue that a spring cannot express. A \
                spring's overshoot decays according to its damping, and you get whatever \
                amplitudes that produces. A rejection needs the amplitudes chosen \
                deliberately — 10, 9, 6, 4, 2, 0 — so the refusal is emphatic at the start \
                and clearly finished at the end.

                keyframeAnimator is the tool for that. It takes an initial value, a trigger, \
                and a track of keyframes each with its own duration, and it replays the \
                whole track every time the trigger changes. That trigger is an integer \
                counter rather than a boolean, because a boolean can only change twice — a \
                counter lets the same shake fire indefinitely without needing a reset.

                CubicKeyframe smooths the direction changes so it reads as a shake rather \
                than as a stutter; SpringKeyframe or LinearKeyframe would give a bouncier or \
                more mechanical version of the same track. The final leg is slightly longer \
                than the rest so the field settles rather than stopping dead.
                """,
            sourceSnippet: #"""
                @State private var attempts = 0

                // Six legs, each with its own duration and target — a spring can't express
                // this, because the amplitude has to decay on a schedule rather than by
                // damping.
                .keyframeAnimator(initialValue: 0.0, trigger: attempts) { content, offset in
                    content.offset(x: offset)
                } keyframes: { _ in
                    KeyframeTrack {
                        CubicKeyframe(-10, duration: 0.07)
                        CubicKeyframe(9, duration: 0.07)
                        CubicKeyframe(-6, duration: 0.07)
                        CubicKeyframe(4, duration: 0.07)
                        CubicKeyframe(-2, duration: 0.07)
                        CubicKeyframe(0, duration: 0.1)
                    }
                }
                .onTapGesture { attempts += 1 }
                .sensoryFeedback(.error, trigger: attempts)

                // No Motion.swift entry — the timing lives in the keyframes, because each
                // leg has its own duration.
                """#,
            kind: .shakeToReject
        ),
        MotionItem(
            id: "hold-to-confirm",
            title: "Hold to confirm",
            category: "Gesture",
            symbolName: "hand.point.up.left.fill",
            description: "The motion is the safeguard: you can see the commitment building, and abandon it.",
            conceptNote: "onLongPressGesture · linear 1.2 fill · easeOut 0.25 unwind",
            documentation: """
                A destructive action that needs deliberate intent, where the animation is \
                doing real work rather than decorating. The ring is a trimmed Circle whose \
                trim end animates from 0 to 1 over 1.2s — the same duration as the gesture's \
                minimumDuration, so the ring completing and the action firing are the same \
                moment. If those two numbers drift apart the control lies to you.

                onPressingChanged fires on both press and release, which is what makes \
                cancellation possible: press starts the fill, release before completion \
                unwinds it. The unwind is deliberately faster (0.25s) and on a different \
                curve, because abandoning an action should feel instant while committing to \
                one should feel considered.

                The fill is linear on purpose. Easing would make the ring appear to \
                accelerate, which misrepresents how much longer you have to hold — the one \
                thing this motion has to communicate honestly. Note also the guard in the \
                release branch: without it, letting go after a successful confirm would \
                unwind the completed ring and undo the feedback.
                """,
            sourceSnippet: #"""
                @State private var progress: CGFloat = 0
                @State private var isPressing = false
                @State private var isConfirmed = false

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        isConfirmed ? Color.green : Color.accentColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                .onLongPressGesture(minimumDuration: 1.2) {
                    confirm()
                } onPressingChanged: { pressing in
                    isPressing = pressing
                    if pressing {
                        withAnimation(Motion.holdFill) {
                            progress = 1
                        }
                    } else if !isConfirmed {
                        // Released early. The ring has to visibly retreat, not vanish.
                        withAnimation(Motion.holdRelease) {
                            progress = 0
                        }
                    }
                }

                // Motion.swift
                static let holdFill = Animation.linear(duration: 1.2)
                static let holdRelease = Animation.easeOut(duration: 0.25)
                """#,
            kind: .holdToConfirm
        ),
        MotionItem(
            id: "pinch-to-zoom",
            title: "Pinch to zoom",
            category: "Gesture",
            symbolName: "arrow.up.left.and.arrow.down.right.circle",
            description: "Rubber-banding back to rest is what tells you the limit was a limit, not a bug.",
            conceptNote: "MagnifyGesture · clamped magnification · spring settle",
            documentation: """
                MagnifyGesture reports a magnification that starts at 1 and scales with the \
                distance between two fingers, so it can be assigned straight to \
                .scaleEffect. As with swipe to delete, the live phase has no animation at \
                all — any curve here would put the panel behind your fingers and break the \
                sense of holding it.

                The clamp between 0.6 and 2.2 is what makes the limits legible: the panel \
                stops growing but your fingers keep going, and that mismatch reads as an \
                edge rather than as a frozen app. The settle back to 1 on release is the \
                only animated part, and it's a spring at 0.7 damping so it overshoots \
                slightly — the same trick as the like burst, and the reason the snap-back \
                feels elastic rather than mechanical.

                Worth knowing on the Simulator: this needs two fingers, so it is Option-drag \
                rather than a click, and it is the only motion here you cannot trigger with \
                a single pointer.
                """,
            sourceSnippet: #"""
                private let minScale: CGFloat = 0.6
                private let maxScale: CGFloat = 2.2

                @State private var scale: CGFloat = 1
                @State private var isPinching = false

                .scaleEffect(scale)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            isPinching = true
                            // Assigned straight from the gesture, unanimated, so the panel
                            // sits exactly where the two fingers put it.
                            scale = min(max(value.magnification, minScale), maxScale)
                        }
                        .onEnded { _ in
                            isPinching = false
                            withAnimation(Motion.pinchSettle) {
                                scale = 1
                            }
                        }
                )
                .sensoryFeedback(.impact(weight: .light), trigger: isPinching)

                // Motion.swift
                static let pinchSettle = Animation.spring(response: 0.35, dampingFraction: 0.7)
                """#,
            kind: .pinchToZoom
        ),
        MotionItem(
            id: "card-flip",
            title: "Card flip",
            category: "Transition",
            symbolName: "rectangle.portrait.rotate",
            description: "Two faces of one object, not two views trading places — and perspective is what sells it.",
            conceptNote: "rotation3DEffect · perspective 0.6 · spring 0.55 · 0.85",
            documentation: """
                Three things have to line up, and the third is the one everybody misses.

                First, the container rotates 180° around the y axis. Second, the back face \
                is *pre*-rotated 180°, so that when the container turns it lands the right \
                way round rather than mirrored — remove that and the back reads as \
                backwards. Third, perspective: at 0 the card squashes horizontally like a \
                closing blind, because there is no depth for the near edge to grow into. \
                0.6 gives a believable amount without the exaggerated fisheye you get \
                nearer 1.

                The fiddly part is the face swap. Both faces exist the whole time, so their \
                opacities have to switch exactly as the card passes edge-on — invisible, \
                halfway through the turn. Left on the flip's own curve, the two faces \
                cross-fade in full view and you see through the card. Hence a separate \
                near-instant animation, scoped to the faces and delayed to ~0.22s, roughly \
                half the spring's settle. Scoping matters: attaching both curves to the \
                whole card lets the outer one win and the swap goes back to fading.
                """,
            sourceSnippet: #"""
                @State private var isFlipped = false

                ZStack {
                    face(symbol: "creditcard.fill", tint: Color.accentColor)
                        .opacity(isFlipped ? 0 : 1)
                        // Scoped to the face, not the whole card: the swap has to land
                        // while the card is edge-on and invisible.
                        .animation(Motion.cardFaceSwap, value: isFlipped)

                    // Pre-rotated a half turn so that when the container flips, this face
                    // ends up the right way round instead of mirrored.
                    face(symbol: "lock.fill", tint: .teal)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .opacity(isFlipped ? 1 : 0)
                        .animation(Motion.cardFaceSwap, value: isFlipped)
                }
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.6
                )
                .animation(Motion.cardFlip, value: isFlipped)
                .onTapGesture { isFlipped.toggle() }
                .sensoryFeedback(.impact(weight: .medium), trigger: isFlipped)

                // Motion.swift
                static let cardFlip = Animation.spring(response: 0.55, dampingFraction: 0.85)
                static let cardFaceSwap = Animation.linear(duration: 0.01).delay(0.22)
                """#,
            kind: .cardFlip
        ),
        MotionItem(
            id: "toast-slide-in",
            title: "Toast slide-in",
            category: "Transition",
            symbolName: "bell.badge.fill",
            description: "Arriving from an edge says where it came from and that it's going back there.",
            conceptNote: "transition · move(edge: .top) + opacity · spring in, easeIn out",
            documentation: """
                No offset is animated here. The toast lives inside an if, so it is genuinely \
                inserted into and removed from the view tree, and .transition describes what \
                should happen at both of those moments. SwiftUI runs the transition in \
                reverse on removal for free — which is why one modifier covers both arrival \
                and departure.

                Combining .move(edge: .top) with .opacity is what stops it looking like a \
                solid object sliding under a bezel. Movement alone reads as mechanical; \
                fading alone loses the sense of direction, and direction is the entire \
                message — this came from the top, so that's where it will go back to.

                Two practical notes. The .clipped() on the container is load-bearing: \
                without it the toast is plainly visible above the panel during its slide, \
                because moving out of a frame doesn't hide anything by itself. And the \
                arrival is a spring while the exit is easeIn, deliberately — an \
                interruption should feel like it has arrived somewhere, and then get out of \
                the way without asking for attention on the way.
                """,
            sourceSnippet: #"""
                @State private var isShowing = false

                ZStack(alignment: .top) {
                    Button { show() } label: {
                        Label("Show toast", systemImage: "bell.badge")
                    }
                    .glassEffect()
                    .frame(maxHeight: .infinity)

                    if isShowing {
                        toast
                            // Attached to a view inside an `if`, so SwiftUI runs this on
                            // insertion and, reversed, on removal.
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .frame(width: 280, height: 170)
                // Without this the toast is visible above the stage while it slides in.
                .clipped()

                private func show() {
                    guard !isShowing else { return }

                    withAnimation(Motion.toastIn) {
                        isShowing = true
                    }

                    Task {
                        try? await Task.sleep(for: .milliseconds(1600))
                        withAnimation(Motion.toastOut) {
                            isShowing = false
                        }
                    }
                }

                // Motion.swift
                static let toastIn = Animation.spring(response: 0.4, dampingFraction: 0.8)
                static let toastOut = Animation.easeIn(duration: 0.25)
                """#,
            kind: .toastSlideIn
        ),
        MotionItem(
            id: "breathing-pulse",
            title: "Breathing pulse",
            category: "Loading",
            symbolName: "circle.dotted",
            description: "The one loading case where reversing the motion is right, rather than a mistake.",
            conceptNote: "repeatForever(autoreverses: true) · easeInOut 0.9",
            documentation: """
                Put this next to the spinner and the shimmer and the difference is the whole \
                lesson. Both of those use repeatForever(autoreverses: false), because a \
                spinner that reversed would read as scrubbing and a highlight that swept \
                backwards would read as undoing. A pulse is the opposite case: it has no \
                direction to contradict, so reversing is not just acceptable, it is what \
                makes it a pulse instead of a stutter.

                That also frees the curve. The spinner has to be linear or it appears to \
                stumble once per revolution; here easeInOut is right, because a swell that \
                slows at each extreme is what reads as breathing rather than as pumping.

                Two layers do the work: a filled circle changing size, and a stroked ring \
                travelling further and fading to nothing. The ring is what turns "a dot \
                resizing" into "something radiating" — and it costs one overlay.
                """,
            sourceSnippet: #"""
                @State private var isSwollen = false

                Circle()
                    .fill(.tint)
                    .frame(width: 44, height: 44)
                    .scaleEffect(isSwollen ? 1.25 : 0.9)
                    .overlay {
                        // A second ring travelling further and fading out entirely, so the
                        // pulse reads as something radiating rather than a dot resizing.
                        Circle()
                            .stroke(.tint, lineWidth: 2)
                            .frame(width: 44, height: 44)
                            .scaleEffect(isSwollen ? 1.9 : 0.9)
                            .opacity(isSwollen ? 0 : 0.7)
                    }

                // in play()
                isSwollen = false
                withAnimation(Motion.breathingPulse) {
                    isSwollen = true
                }

                // Motion.swift
                static let breathingPulse = Animation.easeInOut(duration: 0.9).repeatForever(autoreverses: true)
                """#,
            kind: .breathingPulse
        ),
    ]
}

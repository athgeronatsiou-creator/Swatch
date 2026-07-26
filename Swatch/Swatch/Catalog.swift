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
    ]
}

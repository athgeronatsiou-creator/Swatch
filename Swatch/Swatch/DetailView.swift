//
//  DetailView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct DetailView: View {
    let item: MotionItem

    @EnvironmentObject private var favorites: FavoritesStore

    @State private var isGuidanceExpanded = false
    @State private var isDocumentationExpanded = false
    @State private var isCodeExpanded = false

    var body: some View {
        Group {
            if stageOwnsVerticalDrag {
                // Pull to refresh needs to own the vertical drag, so this screen lays out
                // without an enclosing ScrollView competing for it. (`.scrollDisabled` is
                // not an alternative here: it sets an environment value that propagates
                // down and switches the stage's own list off too.)
                detailContent
            } else {
                ScrollView {
                    detailContent
                }
            }
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: item.shareText, subject: Text(item.title)) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favorites.toggle(item.id)
                } label: {
                    Image(systemName: favorites.contains(item.id) ? "heart.fill" : "heart")
                }
            }
        }
    }

    private var detailContent: some View {
        VStack(spacing: 24) {
            stage

            if stageOwnsVerticalDrag {
                // The notes can't just sit in the VStack on this one screen: with no
                // enclosing ScrollView, an expanded section would run off the bottom with
                // no way to reach it. Its own bounded scroll view fixes that, and being a
                // *sibling* of the stage rather than a parent of it means it never competes
                // for the stage's vertical drag.
                ScrollView {
                    notes
                }
                .frame(maxHeight: 320)
            } else {
                notes
            }
        }
        .padding()
    }

    private var stage: some View {
        Group {
            if stageOwnsVerticalDrag {
                // The usual fixed-height-plus-clip box breaks this one: `.clipped()`
                // only crops a List visually, it doesn't shorten it, so the List never
                // overflows, never bounces, and pull to refresh has nothing to grab.
                // Giving it the spare height means it scrolls for real.
                stageView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                stageView
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()
            }
        }
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 28))
    }

    private var notes: some View {
        VStack(spacing: 24) {
            Text(instruction)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                Text(item.title)
                    .font(.title2.bold())
                Text(item.category.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(item.description)
                    .font(.body)
                Text(item.conceptNote)
                    .font(.system(.caption, design: .monospaced))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(.tertiarySystemBackground), in: Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Guidance sits above the other two deliberately. The order follows how a
            // designer reads this screen: what it is, then whether to use it, then how
            // it works, then the code. Swap the two lines to put the theory first.
            guidanceSection
            documentationSection
            codeSection
        }
    }

    private var guidanceSection: some View {
        expandableSection(
            title: "Design guidelines",
            systemImage: "checklist",
            isExpanded: $isGuidanceExpanded
        ) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    guidanceHeading("WHEN TO USE")
                    Text(item.guidance.whenToUse)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    guidanceHeading("DO")
                    ForEach(item.guidance.dos, id: \.self) { line in
                        guidanceRow(line, systemImage: "checkmark.circle.fill", tint: .green)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    guidanceHeading("DON'T")
                    ForEach(item.guidance.donts, id: \.self) { line in
                        guidanceRow(line, systemImage: "xmark.circle.fill", tint: .red)
                    }
                }
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: isGuidanceExpanded)
    }

    private func guidanceHeading(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
    }

    private func guidanceRow(_ text: String, systemImage: String, tint: Color) -> some View {
        // firstTextBaseline so the icon lines up with the first line of a wrapped row
        // rather than floating in the middle of it.
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: systemImage)
                .font(.caption)
                .foregroundStyle(tint)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
    }

    private var documentationSection: some View {
        expandableSection(
            title: "Documentation",
            systemImage: "text.alignleft",
            isExpanded: $isDocumentationExpanded
        ) {
            Text(item.documentation)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .sensoryFeedback(.impact(weight: .light), trigger: isDocumentationExpanded)
    }

    private var codeSection: some View {
        expandableSection(
            title: "Code",
            systemImage: "chevron.left.forwardslash.chevron.right",
            isExpanded: $isCodeExpanded
        ) {
            // Deliberately plain: one monospaced Text in the primary colour, no
            // highlighting and nothing parsing the snippet. Code lines are wider than the
            // screen, so they scroll sideways rather than wrap into nonsense.
            ScrollView(.horizontal, showsIndicators: false) {
                Text(item.sourceSnippet)
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: isCodeExpanded)
    }

    /// A collapsed-by-default section that expands in place. `DisclosureGroup` is the stock
    /// control for this, and it animates its own open/close, so there is no motion to write.
    private func expandableSection<Content: View>(
        title: String,
        systemImage: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        // Built up front rather than inside the group: `DisclosureGroup` holds on to its
        // content, so passing the closure straight through would need it to escape.
        let expandedContent = content()

        return DisclosureGroup(isExpanded: isExpanded) {
            expandedContent
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
        } label: {
            Label(title, systemImage: systemImage)
                .font(.headline)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder
    private var stageView: some View {
        switch item.kind {
        case .pressScale:
            PressScaleView()
        case .toggleSwitch:
            ToggleSwitchView()
        case .likeBurst:
            LikeBurstView()
        case .drawnCheckmark:
            DrawnCheckmarkView()
        case .iconMorph:
            IconMorphView()
        case .slidingSegmentPill:
            SlidingSegmentPillView()
        case .rollingCounter:
            RollingCounterView()
        case .progressiveButton:
            ProgressiveButtonView()
        case .skeletonShimmer:
            SkeletonShimmerView()
        case .spinner:
            SpinnerView()
        case .progressBarFill:
            ProgressBarFillView()
        case .swipeToDelete:
            SwipeToDeleteView()
        case .pullToRefresh:
            PullToRefreshView()
        case .dragToReorder:
            DragToReorderView()
        case .modalPresentation:
            ModalPresentationView()
        case .sharedElementPush:
            SharedElementPushView()
        case .radialReveal:
            RadialRevealView()
        case .staggeredListReveal:
            StaggeredListRevealView()
        case .shakeToReject:
            ShakeToRejectView()
        case .holdToConfirm:
            HoldToConfirmView()
        case .pinchToZoom:
            PinchToZoomView()
        case .cardFlip:
            CardFlipView()
        case .toastSlideIn:
            ToastSlideInView()
        case .breathingPulse:
            BreathingPulseView()
        }
    }

    private var stageOwnsVerticalDrag: Bool {
        item.kind == .pullToRefresh
    }

    private var instruction: String {
        switch item.kind {
        case .pressScale: "Tap to press"
        case .toggleSwitch: "Tap to toggle"
        case .likeBurst: "Tap to like"
        case .drawnCheckmark: "Tap to check"
        case .iconMorph: "Tap to play"
        case .slidingSegmentPill: "Tap a segment to select"
        case .rollingCounter: "Tap to count"
        case .progressiveButton: "Tap to submit"
        case .skeletonShimmer: "Tap to simulate loading"
        case .spinner: "Tap to simulate loading"
        case .progressBarFill: "Tap to simulate loading"
        case .swipeToDelete: "Swipe left to delete"
        case .pullToRefresh: "Pull down to refresh"
        case .dragToReorder: "Drag a row to reorder"
        case .modalPresentation: "Tap to present"
        case .sharedElementPush: "Go back to watch it happen in reverse"
        case .radialReveal: "Tap anywhere — the reveal starts where you touch"
        case .staggeredListReveal: "Tap to reveal, tap again to clear"
        case .shakeToReject: "Tap to submit"
        case .holdToConfirm: "Press and hold to confirm — let go early to cancel"
        case .pinchToZoom: "Pinch to zoom (two fingers)"
        case .cardFlip: "Tap to flip"
        case .toastSlideIn: "Tap to show the toast"
        case .breathingPulse: "Tap to simulate loading"
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(item: Catalog.all[0])
            .environmentObject(FavoritesStore())
    }
}

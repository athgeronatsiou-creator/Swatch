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
            kind: .pressScale
        ),
        MotionItem(
            id: "toggle-switch",
            title: "Toggle switch",
            category: "State change",
            symbolName: "switch.2",
            description: "Coordinated movement plus colour interpolation.",
            conceptNote: "easeInOut · duration 0.25",
            kind: .toggleSwitch
        ),
        MotionItem(
            id: "like-burst",
            title: "Like burst",
            category: "Feedback",
            symbolName: "heart.fill",
            description: "Settling past the target reads as more satisfying than landing on it exactly.",
            conceptNote: "spring · response 0.4 · damping 0.4",
            kind: .likeBurst
        ),
        MotionItem(
            id: "drawn-checkmark",
            title: "Drawn checkmark",
            category: "Reveal",
            symbolName: "checkmark.circle.fill",
            description: "The shape draws in before it settles, instead of just appearing.",
            conceptNote: "Path · trim · easeOut 0.4",
            kind: .drawnCheckmark
        ),
        MotionItem(
            id: "icon-morph",
            title: "Icon morph",
            category: "State change",
            symbolName: "playpause.fill",
            description: "The symbol morphs into its next state instead of swapping instantly.",
            conceptNote: "contentTransition · symbolEffect(.replace)",
            kind: .iconMorph
        ),
        MotionItem(
            id: "sliding-segment-pill",
            title: "Sliding segment pill",
            category: "State change",
            symbolName: "capsule.fill",
            description: "The selection indicator slides to its new position rather than jumping.",
            conceptNote: "matchedGeometryEffect · spring 0.35 · 0.75",
            kind: .slidingSegmentPill
        ),
        MotionItem(
            id: "rolling-counter",
            title: "Rolling counter",
            category: "State change",
            symbolName: "textformat.123",
            description: "The value rolls through the numbers in between, instead of cutting straight to the new one.",
            conceptNote: "contentTransition · numericText",
            kind: .rollingCounter
        ),
        MotionItem(
            id: "progressive-button",
            title: "Progressive button",
            category: "Feedback",
            symbolName: "paperplane.fill",
            description: "One control carries the whole journey: idle, loading, then success.",
            conceptNote: "state machine · idle → loading → success",
            kind: .progressiveButton
        ),
        MotionItem(
            id: "skeleton-shimmer",
            title: "Skeleton shimmer",
            category: "Loading",
            symbolName: "rectangle.dashed",
            description: "A placeholder that moves reads as 'still working' — a static one reads as broken.",
            conceptNote: "gradient sweep · linear 1.1s · repeatForever",
            kind: .skeletonShimmer
        ),
        MotionItem(
            id: "spinner",
            title: "Spinner",
            category: "Loading",
            symbolName: "arrow.clockwise",
            description: "No progress to report yet, so the motion itself is the only signal that something is happening.",
            conceptNote: "rotationEffect · linear 0.9s · repeatForever",
            kind: .spinner
        ),
        MotionItem(
            id: "progress-bar-fill",
            title: "Progress bar fill",
            category: "Loading",
            symbolName: "gauge",
            description: "Once you can report real progress, showing it beats a generic spinner every time.",
            conceptNote: "width animation · easeInOut 1.4s",
            kind: .progressBarFill
        ),
        MotionItem(
            id: "swipe-to-delete",
            title: "Swipe to delete",
            category: "Gesture",
            symbolName: "trash.fill",
            description: "The reveal has to track your finger exactly, or the gesture stops feeling direct.",
            conceptNote: "DragGesture · translation-driven offset",
            kind: .swipeToDelete
        ),
        MotionItem(
            id: "pull-to-refresh",
            title: "Pull to refresh",
            category: "Gesture",
            symbolName: "arrow.down.circle",
            description: "Built into List and ScrollView — the whole interaction ships for one modifier.",
            conceptNote: "refreshable · system-driven",
            kind: .pullToRefresh
        ),
        MotionItem(
            id: "drag-to-reorder",
            title: "Drag to reorder",
            category: "Gesture",
            symbolName: "line.3.horizontal",
            description: "The list makes room before you let go, not after.",
            conceptNote: "onMove · List edit mode",
            kind: .dragToReorder
        ),
        MotionItem(
            id: "modal-presentation",
            title: "Modal presentation",
            category: "Transition",
            symbolName: "square.on.square",
            description: "A sheet says 'this is temporary, dismiss whenever' just by how it arrives.",
            conceptNote: "sheet · content transition on appear",
            kind: .modalPresentation
        ),
        MotionItem(
            id: "shared-element-push",
            title: "Shared-element push",
            category: "Transition",
            symbolName: "arrow.up.left.and.arrow.down.right",
            description: "The card doesn't disappear and get replaced by the next screen — it grows into it.",
            conceptNote: "navigationTransition(.zoom) · shared namespace",
            kind: .sharedElementPush
        ),
    ]
}

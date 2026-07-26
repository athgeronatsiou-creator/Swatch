//
//  MotionItem.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import Foundation

enum MotionKind: Hashable {
    case pressScale
    case toggleSwitch
    case likeBurst
    case drawnCheckmark
    case iconMorph
    case slidingSegmentPill
    case rollingCounter
    case progressiveButton
    case skeletonShimmer
    case spinner
    case progressBarFill
    case swipeToDelete
    case pullToRefresh
    case dragToReorder
    case modalPresentation
    case sharedElementPush
    case radialReveal
    case staggeredListReveal
    case shakeToReject
    case holdToConfirm
    case pinchToZoom
    case cardFlip
    case toastSlideIn
    case breathingPulse
}

/// Guidance for the person *choosing* a motion, as opposed to the person implementing
/// it: where it belongs, and the specific ways it goes wrong. Kept structured rather
/// than as prose so the detail screen can render the dos and don'ts as scannable lists.
struct DesignGuidance: Hashable {
    let whenToUse: String
    let dos: [String]
    let donts: [String]
}

struct MotionItem: Identifiable, Hashable {
    let id: String
    let title: String
    let category: String
    let symbolName: String
    let description: String
    let conceptNote: String
    /// The long-form explanation: how the motion is built and why it is built that way.
    let documentation: String
    /// The motion's key SwiftUI logic, copied from its own file as plain text.
    let sourceSnippet: String
    /// When to reach for this motion, and how it goes wrong.
    let guidance: DesignGuidance
    let kind: MotionKind
}

extension MotionItem {
    /// Plain-text summary shared by the detail screen's `ShareLink`.
    var shareText: String {
        """
        \(title) — \(category)

        \(description)

        CONCEPT
        \(conceptNote)

        CODE
        \(sourceSnippet)

        Shared from Swatch, a SwiftUI motion library.
        """
    }
}

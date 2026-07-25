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
}

struct MotionItem: Identifiable, Hashable {
    let id: String
    let title: String
    let category: String
    let symbolName: String
    let description: String
    let conceptNote: String
    let kind: MotionKind
}

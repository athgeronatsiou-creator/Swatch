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
    ]
}

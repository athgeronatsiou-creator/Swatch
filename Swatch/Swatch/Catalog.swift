//
//  Catalog.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

enum Catalog {
    static let all: [MotionItem] = [
        MotionItem(
            id: "press-scale",
            title: "Press scale",
            category: "Feedback",
            symbolName: "hand.tap.fill",
            description: "Confirms the tap landed. Too much scale reads as broken.",
            conceptNote: "spring · response 0.35 · damping 0.7",
            stage: { trigger in AnyView(PressScaleView(replayTrigger: trigger)) }
        ),
        MotionItem(
            id: "toggle-switch",
            title: "Toggle switch",
            category: "State change",
            symbolName: "switch.2",
            description: "Coordinated movement plus colour interpolation.",
            conceptNote: "easeInOut · duration 0.25",
            stage: { trigger in AnyView(ToggleSwitchView(replayTrigger: trigger)) }
        ),
    ]
}

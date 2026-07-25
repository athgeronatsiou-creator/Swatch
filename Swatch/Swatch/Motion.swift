//
//  Motion.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

enum Motion {
    // Press scale: icon pops in by scaling up from 0.
    static let pressScale = Animation.spring(response: 0.35, dampingFraction: 0.7)

    // Toggle switch: thumb slides and track colour blends together.
    static let toggleSwitch = Animation.easeInOut(duration: 0.25)

    // Like burst: low damping lets the scale overshoot before settling.
    static let likeBurst = Animation.spring(response: 0.4, dampingFraction: 0.4)

    // Drawn checkmark: path traces in, then a quick settle pulse.
    static let checkmarkDraw = Animation.easeOut(duration: 0.4)
    static let checkmarkSettle = Animation.spring(response: 0.3, dampingFraction: 0.5)

    // Icon morph: symbol content crossfades to its next state.
    static let iconMorph = Animation.easeInOut(duration: 0.3)

    // Sliding segment pill: shared-element pill slides to the new segment.
    static let segmentSlide = Animation.spring(response: 0.35, dampingFraction: 0.75)

    // Rolling counter: digits roll to the new value.
    static let counterRoll = Animation.spring(response: 0.45, dampingFraction: 0.8)

    // Progressive button: width and label morph between stages.
    static let progressiveButton = Animation.spring(response: 0.4, dampingFraction: 0.75)
}

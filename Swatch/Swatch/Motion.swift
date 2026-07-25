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

    // Loading category: shared idle/loading/complete state-machine transition.
    static let loadStageChange = Animation.spring(response: 0.4, dampingFraction: 0.75)

    // Skeleton shimmer: highlight sweeps across the placeholder, looping while "loading".
    static let shimmerSweep = Animation.linear(duration: 1.1).repeatForever(autoreverses: false)

    // Spinner: constant rotation while "loading".
    static let spinnerRotate = Animation.linear(duration: 0.9).repeatForever(autoreverses: false)

    // Progress bar fill: width eases to full over the simulated load duration.
    static let progressBarFill = Animation.easeInOut(duration: 1.4)

    // Swipe to delete: reveal snaps open/closed; the row itself eases out on release past threshold.
    static let swipeSnap = Animation.spring(response: 0.35, dampingFraction: 0.8)
    static let swipeRemove = Animation.easeIn(duration: 0.25)

    // Pull to refresh: refreshed content eases in once the simulated fetch completes.
    static let refreshContentUpdate = Animation.easeOut(duration: 0.3)

    // Modal presentation: sheet content fades and scales in once the sheet settles.
    static let modalContentReveal = Animation.spring(response: 0.4, dampingFraction: 0.8)
}

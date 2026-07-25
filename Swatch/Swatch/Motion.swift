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
}

//
//  PressScaleView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct PressScaleView: View {
    @State private var scale = 1.0
    @State private var isPressed = false

    var body: some View {
        Image(systemName: "hand.tap.fill")
            .font(.system(size: 60))
            .foregroundStyle(.tint)
            .scaleEffect(scale)
            .onTapGesture { play() }
            .sensoryFeedback(.impact(weight: .light), trigger: isPressed)
    }

    private func play() {
        isPressed.toggle()
        scale = 0
        withAnimation(Motion.pressScale) {
            scale = 1
        }
    }
}

#Preview {
    PressScaleView()
}

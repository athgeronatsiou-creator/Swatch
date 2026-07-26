//
//  PinchToZoomView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

private let minScale: CGFloat = 0.6
private let maxScale: CGFloat = 2.2

struct PinchToZoomView: View {
    @State private var scale: CGFloat = 1
    @State private var isPinching = false

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.accentColor.opacity(0.15))
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 44))
                    .foregroundStyle(.tint)
            }
            .frame(width: 160, height: 120)
            .scaleEffect(scale)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        isPinching = true
                        // Assigned straight from the gesture, unanimated, so the panel
                        // sits exactly where the two fingers put it.
                        scale = min(max(value.magnification, minScale), maxScale)
                    }
                    .onEnded { _ in
                        isPinching = false
                        withAnimation(Motion.pinchSettle) {
                            scale = 1
                        }
                    }
            )
            .sensoryFeedback(.impact(weight: .light), trigger: isPinching)
    }
}

#Preview {
    PinchToZoomView()
}

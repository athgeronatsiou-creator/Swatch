//
//  RadialRevealView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct RadialRevealView: View {
    @State private var origin: CGPoint = .zero
    @State private var revealScale: CGFloat = 0
    @State private var isRevealed = false

    private let panel = CGSize(width: 240, height: 140)

    // Big enough that a circle centred in any corner still reaches the far one.
    private var diameter: CGFloat {
        2 * hypot(panel.width, panel.height)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray5))
                .overlay {
                    Text("Tap anywhere")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

            RoundedRectangle(cornerRadius: 16)
                .fill(.tint)
                .overlay {
                    Image(systemName: "sparkles")
                        .font(.system(size: 36))
                        .foregroundStyle(.white)
                }
                .mask(alignment: .topLeading) {
                    // Centred on the touch point, then scaled from nothing. Scaling the
                    // mask rather than the layer is what keeps the revealed content still
                    // while the opening grows over it.
                    Circle()
                        .frame(width: diameter, height: diameter)
                        .scaleEffect(revealScale)
                        .offset(x: origin.x - diameter / 2, y: origin.y - diameter / 2)
                }
        }
        .frame(width: panel.width, height: panel.height)
        .contentShape(Rectangle())
        .onTapGesture(coordinateSpace: .local) { location in
            reveal(from: location)
        }
        .sensoryFeedback(trigger: isRevealed) { _, newValue in
            newValue ? .impact(weight: .light) : nil
        }
    }

    private func reveal(from location: CGPoint) {
        guard !isRevealed else { return }

        // Both of these are set outside the animation: the circle has to jump to the new
        // touch point, not slide there from the last one.
        origin = location
        revealScale = 0
        isRevealed = true

        withAnimation(Motion.radialReveal) {
            revealScale = 1
        }

        Task {
            try? await Task.sleep(for: .milliseconds(1100))
            withAnimation(Motion.radialReveal) {
                revealScale = 0
            }
            isRevealed = false
        }
    }
}

#Preview {
    RadialRevealView()
}

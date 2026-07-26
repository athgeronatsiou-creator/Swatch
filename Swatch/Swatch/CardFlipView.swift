//
//  CardFlipView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct CardFlipView: View {
    @State private var isFlipped = false

    var body: some View {
        ZStack {
            face(symbol: "creditcard.fill", tint: Color.accentColor)
                .opacity(isFlipped ? 0 : 1)
                // Scoped to the face, not to the whole card: the swap has to land while
                // the card is edge-on and invisible. Left on the flip's own curve, the
                // two faces cross-fade in full view and the illusion breaks.
                .animation(Motion.cardFaceSwap, value: isFlipped)

            // Pre-rotated a half turn so that when the container flips, this face ends up
            // the right way round instead of mirrored.
            face(symbol: "lock.fill", tint: .teal)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
                .animation(Motion.cardFaceSwap, value: isFlipped)
        }
        // Perspective is what stops this reading as a flat horizontal squash: the near
        // edge has to grow as it swings towards you.
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.6
        )
        .animation(Motion.cardFlip, value: isFlipped)
        .contentShape(Rectangle())
        .onTapGesture { isFlipped.toggle() }
        .sensoryFeedback(.impact(weight: .medium), trigger: isFlipped)
    }

    private func face(symbol: String, tint: Color) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(tint.opacity(0.15))
            .frame(width: 170, height: 110)
            .overlay {
                Image(systemName: symbol)
                    .font(.system(size: 40))
                    .foregroundStyle(tint)
            }
    }
}

#Preview {
    CardFlipView()
}

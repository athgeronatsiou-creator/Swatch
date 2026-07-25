//
//  LikeBurstView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct LikeBurstView: View {
    @State private var isLiked = false

    var body: some View {
        Image(systemName: isLiked ? "heart.fill" : "heart")
            .font(.system(size: 60))
            .foregroundStyle(isLiked ? .red : .secondary)
            .scaleEffect(isLiked ? 1 : 0.8)
            .onTapGesture { play() }
            .sensoryFeedback(trigger: isLiked) { _, newValue in
                newValue ? .success : .impact(weight: .light)
            }
    }

    private func play() {
        withAnimation(Motion.likeBurst) {
            isLiked.toggle()
        }
    }
}

#Preview {
    LikeBurstView()
}

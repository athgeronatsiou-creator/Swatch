//
//  LikeBurstView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct LikeBurstView: View {
    var replayTrigger: Int = 0
    @State private var scale = 0.0

    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 60))
            .foregroundStyle(.red)
            .scaleEffect(scale)
            .onChange(of: replayTrigger) { _, _ in play() }
    }

    private func play() {
        scale = 0
        withAnimation(Motion.likeBurst) {
            scale = 1
        }
    }
}

#Preview {
    LikeBurstView()
}

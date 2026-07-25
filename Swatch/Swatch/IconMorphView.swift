//
//  IconMorphView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct IconMorphView: View {
    @State private var isPlaying = false

    var body: some View {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            .font(.system(size: 60))
            .foregroundStyle(.tint)
            .contentTransition(.symbolEffect(.replace))
            .onTapGesture { play() }
    }

    private func play() {
        withAnimation(Motion.iconMorph) {
            isPlaying.toggle()
        }
    }
}

#Preview {
    IconMorphView()
}

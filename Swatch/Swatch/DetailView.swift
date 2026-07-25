//
//  DetailView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct DetailView: View {
    @State private var iconScale = 0.0

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .scaleEffect(iconScale)
                .onAppear { play() }

            Button("Replay", action: play)
        }
        .padding(30)
    }

    private func play() {
        iconScale = 0
        withAnimation(Motion.pressScale) {
            iconScale = 1
        }
    }
}

#Preview {
    DetailView()
}

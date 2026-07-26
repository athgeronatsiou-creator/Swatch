//
//  BreathingPulseView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

private enum LoadStage: Equatable {
    case idle, loading, loaded
}

struct BreathingPulseView: View {
    @State private var stage: LoadStage = .idle
    @State private var isSwollen = false

    var body: some View {
        Group {
            switch stage {
            case .idle:
                Button("Simulate load") { play() }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .glassEffect()
            case .loading:
                pulsingDot
            case .loaded:
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.tint)
            }
        }
        .sensoryFeedback(trigger: stage) { _, newValue in
            switch newValue {
            case .loading: .impact(weight: .light)
            case .loaded: .success
            case .idle: nil
            }
        }
    }

    private var pulsingDot: some View {
        Circle()
            .fill(.tint)
            .frame(width: 44, height: 44)
            .scaleEffect(isSwollen ? 1.25 : 0.9)
            .overlay {
                // A second ring travelling further and fading out entirely, so the pulse
                // reads as something radiating rather than just a dot changing size.
                Circle()
                    .stroke(.tint, lineWidth: 2)
                    .frame(width: 44, height: 44)
                    .scaleEffect(isSwollen ? 1.9 : 0.9)
                    .opacity(isSwollen ? 0 : 0.7)
            }
    }

    private func play() {
        guard stage == .idle else { return }
        stage = .loading
        isSwollen = false
        withAnimation(Motion.breathingPulse) {
            isSwollen = true
        }
        Task {
            try? await Task.sleep(for: .milliseconds(1800))
            withAnimation(Motion.loadStageChange) {
                stage = .loaded
            }
            try? await Task.sleep(for: .milliseconds(900))
            withAnimation(Motion.loadStageChange) {
                stage = .idle
            }
        }
    }
}

#Preview {
    BreathingPulseView()
}

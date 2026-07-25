//
//  SpinnerView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

private enum LoadStage: Equatable {
    case idle, loading, loaded
}

struct SpinnerView: View {
    @State private var stage: LoadStage = .idle
    @State private var rotation: Double = 0

    var body: some View {
        Group {
            switch stage {
            case .idle:
                Button("Simulate load") { play() }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .glassEffect()
            case .loading:
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(.tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotation))
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

    private func play() {
        guard stage == .idle else { return }
        stage = .loading
        rotation = 0
        withAnimation(Motion.spinnerRotate) {
            rotation = 360
        }
        Task {
            try? await Task.sleep(for: .milliseconds(1400))
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
    SpinnerView()
}

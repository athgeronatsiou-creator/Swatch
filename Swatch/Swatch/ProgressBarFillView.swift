//
//  ProgressBarFillView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

private enum LoadStage: Equatable {
    case idle, loading, loaded
}

struct ProgressBarFillView: View {
    @State private var stage: LoadStage = .idle
    @State private var fillWidth: CGFloat = 0

    private let trackWidth: CGFloat = 200

    var body: some View {
        Group {
            switch stage {
            case .idle:
                Button("Simulate load") { play() }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .glassEffect()
            case .loading:
                progressTrack
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

    private var progressTrack: some View {
        Capsule()
            .fill(Color(.systemGray5))
            .frame(width: trackWidth, height: 12)
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(.tint)
                    .frame(width: fillWidth, height: 12)
            }
    }

    private func play() {
        guard stage == .idle else { return }
        stage = .loading
        fillWidth = 0
        withAnimation(Motion.progressBarFill) {
            fillWidth = trackWidth
        }
        Task {
            try? await Task.sleep(for: .milliseconds(1500))
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
    ProgressBarFillView()
}

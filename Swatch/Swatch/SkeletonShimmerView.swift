//
//  SkeletonShimmerView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

private enum LoadStage: Equatable {
    case idle, loading, loaded
}

struct SkeletonShimmerView: View {
    @State private var stage: LoadStage = .idle
    @State private var sweepOffset: CGFloat = -160

    var body: some View {
        Group {
            switch stage {
            case .idle:
                Button("Simulate load") { play() }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .glassEffect()
            case .loading:
                skeletonBlock
            case .loaded:
                loadedBlock
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

    private var skeletonBlock: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray5))
            .frame(width: 200, height: 100)
            .overlay {
                LinearGradient(
                    colors: [.clear, Color.white.opacity(0.7), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 120)
                .offset(x: sweepOffset)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var loadedBlock: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.accentColor.opacity(0.15))
            .frame(width: 200, height: 100)
            .overlay {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.tint)
            }
    }

    private func play() {
        guard stage == .idle else { return }
        stage = .loading
        sweepOffset = -160
        withAnimation(Motion.shimmerSweep) {
            sweepOffset = 160
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
    SkeletonShimmerView()
}

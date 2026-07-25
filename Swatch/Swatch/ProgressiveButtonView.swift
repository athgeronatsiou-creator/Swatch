//
//  ProgressiveButtonView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

private enum ButtonStage {
    case idle, loading, success
}

struct ProgressiveButtonView: View {
    @State private var stage: ButtonStage = .idle

    var body: some View {
        Group {
            switch stage {
            case .idle:
                Text("Submit")
            case .loading:
                ProgressView()
                    .tint(.white)
            case .success:
                Label("Done", systemImage: "checkmark")
            }
        }
        .font(.headline)
        .foregroundStyle(.white)
        .frame(width: width, height: 44)
        .background(stage == .success ? Color.green : Color.accentColor, in: Capsule())
        .onTapGesture { play() }
        .sensoryFeedback(trigger: stage) { _, newValue in
            switch newValue {
            case .loading: .impact(weight: .light)
            case .success: .success
            case .idle: nil
            }
        }
    }

    private var width: CGFloat {
        switch stage {
        case .idle: 120
        case .loading: 60
        case .success: 110
        }
    }

    private func play() {
        guard stage == .idle else { return }
        Task {
            withAnimation(Motion.progressiveButton) {
                stage = .loading
            }
            try? await Task.sleep(for: .milliseconds(900))
            withAnimation(Motion.progressiveButton) {
                stage = .success
            }
            try? await Task.sleep(for: .milliseconds(900))
            withAnimation(Motion.progressiveButton) {
                stage = .idle
            }
        }
    }
}

#Preview {
    ProgressiveButtonView()
}

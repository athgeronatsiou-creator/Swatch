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
    var replayTrigger: Int = 0
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
        .onChange(of: replayTrigger) { _, _ in play() }
    }

    private var width: CGFloat {
        switch stage {
        case .idle: 120
        case .loading: 60
        case .success: 110
        }
    }

    private func play() {
        stage = .idle
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(Motion.progressiveButton) {
                stage = .loading
            }
            try? await Task.sleep(for: .milliseconds(900))
            withAnimation(Motion.progressiveButton) {
                stage = .success
            }
        }
    }
}

#Preview {
    ProgressiveButtonView()
}

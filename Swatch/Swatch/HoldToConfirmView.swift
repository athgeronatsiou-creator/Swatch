//
//  HoldToConfirmView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct HoldToConfirmView: View {
    @State private var progress: CGFloat = 0
    @State private var isPressing = false
    @State private var isConfirmed = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 8)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    isConfirmed ? Color.green : Color.accentColor,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Image(systemName: isConfirmed ? "checkmark" : "trash.fill")
                .font(.system(size: 26))
                .foregroundStyle(isConfirmed ? .green : .primary)
                .contentTransition(.symbolEffect(.replace))
        }
        .frame(width: 96, height: 96)
        .contentShape(Circle())
        .onLongPressGesture(minimumDuration: 1.2) {
            confirm()
        } onPressingChanged: { pressing in
            isPressing = pressing
            if pressing {
                withAnimation(Motion.holdFill) {
                    progress = 1
                }
            } else if !isConfirmed {
                // Released early. The ring has to visibly retreat, not vanish — that's
                // what tells you the action was abandoned rather than performed.
                withAnimation(Motion.holdRelease) {
                    progress = 0
                }
            }
        }
        .sensoryFeedback(trigger: isPressing) { _, newValue in
            newValue ? .impact(weight: .light) : nil
        }
        .sensoryFeedback(trigger: isConfirmed) { _, newValue in
            newValue ? .success : nil
        }
    }

    private func confirm() {
        isConfirmed = true
        Task {
            try? await Task.sleep(for: .milliseconds(1000))
            withAnimation(Motion.holdRelease) {
                progress = 0
            }
            isConfirmed = false
        }
    }
}

#Preview {
    HoldToConfirmView()
}

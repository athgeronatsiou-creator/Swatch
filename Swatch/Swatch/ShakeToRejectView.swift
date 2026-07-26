//
//  ShakeToRejectView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct ShakeToRejectView: View {
    @State private var attempts = 0

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock.fill")
                .foregroundStyle(.red)
            Text(verbatim: "••••••••")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(width: 240, height: 48)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.red, lineWidth: 1.5)
        }
        // Six legs, each with its own duration and target — a spring can't express this,
        // because the amplitude has to decay on a schedule rather than by damping.
        .keyframeAnimator(initialValue: 0.0, trigger: attempts) { content, offset in
            content.offset(x: offset)
        } keyframes: { _ in
            KeyframeTrack {
                CubicKeyframe(-10, duration: 0.07)
                CubicKeyframe(9, duration: 0.07)
                CubicKeyframe(-6, duration: 0.07)
                CubicKeyframe(4, duration: 0.07)
                CubicKeyframe(-2, duration: 0.07)
                CubicKeyframe(0, duration: 0.1)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { attempts += 1 }
        .sensoryFeedback(.error, trigger: attempts)
    }
}

#Preview {
    ShakeToRejectView()
}

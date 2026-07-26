//
//  ToastSlideInView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct ToastSlideInView: View {
    @State private var isShowing = false

    var body: some View {
        ZStack(alignment: .top) {
            Button {
                show()
            } label: {
                Label("Show toast", systemImage: "bell.badge")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            .glassEffect()
            .frame(maxHeight: .infinity)

            if isShowing {
                toast
                    // The transition describes how it arrives *and* leaves. Because it's
                    // attached to a view inside an `if`, SwiftUI runs it on insertion and
                    // removal — there is no offset to animate by hand.
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(width: 280, height: 170)
        // Without this the toast is visible above the stage while it slides in.
        .clipped()
        .sensoryFeedback(trigger: isShowing) { _, newValue in
            newValue ? .success : nil
        }
    }

    private var toast: some View {
        Label("Saved to favourites", systemImage: "checkmark.circle.fill")
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect()
    }

    private func show() {
        guard !isShowing else { return }

        withAnimation(Motion.toastIn) {
            isShowing = true
        }

        Task {
            try? await Task.sleep(for: .milliseconds(1600))
            withAnimation(Motion.toastOut) {
                isShowing = false
            }
        }
    }
}

#Preview {
    ToastSlideInView()
}

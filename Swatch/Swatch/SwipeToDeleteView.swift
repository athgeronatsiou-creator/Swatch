//
//  SwipeToDeleteView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

private let deleteThreshold: CGFloat = -80
private let maxDrag: CGFloat = -140
private let rowWidth: CGFloat = 260

struct SwipeToDeleteView: View {
    @State private var offset: CGFloat = 0
    @State private var isPastThreshold = false
    @State private var isDeleting = false

    var body: some View {
        ZStack(alignment: .trailing) {
            Capsule()
                .fill(Color.red)
                .overlay(alignment: .trailing) {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.white)
                        .padding(.trailing, 24)
                }

            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundStyle(.tint)
                Text("Swipe me")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color(.systemBackground), in: Capsule())
            .offset(x: offset)
            .opacity(isDeleting ? 0 : 1)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isDeleting else { return }
                        offset = max(min(value.translation.width, 0), maxDrag)
                        isPastThreshold = offset < deleteThreshold
                    }
                    .onEnded { _ in
                        guard !isDeleting else { return }
                        if offset < deleteThreshold {
                            commitDelete()
                        } else {
                            withAnimation(Motion.swipeSnap) {
                                offset = 0
                            }
                        }
                    }
            )
        }
        .frame(width: rowWidth, height: 56)
        .clipShape(Capsule())
        .sensoryFeedback(.impact(weight: .medium), trigger: isPastThreshold)
        .sensoryFeedback(trigger: isDeleting) { _, newValue in
            newValue ? .warning : nil
        }
    }

    private func commitDelete() {
        withAnimation(Motion.swipeRemove) {
            offset = -rowWidth
            isDeleting = true
        }
        Task {
            try? await Task.sleep(for: .milliseconds(700))
            offset = 0
            isPastThreshold = false
            withAnimation(Motion.swipeSnap) {
                isDeleting = false
            }
        }
    }
}

#Preview {
    SwipeToDeleteView()
}

//
//  StaggeredListRevealView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct StaggeredListRevealView: View {
    @State private var isRevealed = false

    private let rows: [(symbol: String, title: String)] = [
        ("tray.fill", "Inbox"),
        ("pencil", "Drafts"),
        ("paperplane.fill", "Sent"),
        ("archivebox.fill", "Archive"),
    ]

    var body: some View {
        ZStack {
            // Without this the stage is simply blank at rest — correct, since nothing may
            // animate on appear, but it leaves nothing to aim at and reads as broken.
            Text("Tap to reveal")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .opacity(isRevealed ? 0 : 1)
                .animation(Motion.staggerRow, value: isRevealed)

            VStack(spacing: 8) {
                ForEach(rows.indices, id: \.self) { index in
                    row(index)
                        .opacity(isRevealed ? 1 : 0)
                        .offset(y: isRevealed ? 0 : 14)
                        // One state change, four different start times. The delay is the
                        // whole mechanism — everything else is identical per row.
                        .animation(
                            Motion.staggerRow.delay(Double(index) * Motion.staggerDelayStep),
                            value: isRevealed
                        )
                }
            }
        }
        // 4 rows of 40 plus 3 gaps of 8 — fixed so the hint stays centred on the rows.
        .frame(width: 220, height: 184)
        .contentShape(Rectangle())
        .onTapGesture { isRevealed.toggle() }
        .sensoryFeedback(.impact(weight: .light), trigger: isRevealed)
    }

    private func row(_ index: Int) -> some View {
        HStack(spacing: 12) {
            Image(systemName: rows[index].symbol)
                .foregroundStyle(.tint)
                .frame(width: 20)
            Text(rows[index].title)
                .font(.subheadline)
            Spacer()
        }
        .padding(.horizontal, 14)
        .frame(height: 40)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    StaggeredListRevealView()
}

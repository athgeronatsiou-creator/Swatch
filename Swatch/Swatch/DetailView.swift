//
//  DetailView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct DetailView: View {
    let item: MotionItem

    @EnvironmentObject private var favorites: FavoritesStore
    @State private var replayTrigger = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                stageView
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 28))

                Button {
                    replayTrigger += 1
                } label: {
                    Label("Replay", systemImage: "arrow.clockwise")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .glassEffect()

                VStack(alignment: .leading, spacing: 12) {
                    Text(item.title)
                        .font(.title2.bold())
                    Text(item.category.uppercased())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(item.description)
                        .font(.body)
                    Text(item.conceptNote)
                        .font(.system(.caption, design: .monospaced))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(.tertiarySystemBackground), in: Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favorites.toggle(item.id)
                } label: {
                    Image(systemName: favorites.contains(item.id) ? "heart.fill" : "heart")
                }
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(400))
            replayTrigger += 1
        }
    }

    @ViewBuilder
    private var stageView: some View {
        switch item.kind {
        case .pressScale:
            PressScaleView(replayTrigger: replayTrigger)
        case .toggleSwitch:
            ToggleSwitchView(replayTrigger: replayTrigger)
        case .likeBurst:
            LikeBurstView(replayTrigger: replayTrigger)
        case .drawnCheckmark:
            DrawnCheckmarkView(replayTrigger: replayTrigger)
        case .iconMorph:
            IconMorphView(replayTrigger: replayTrigger)
        case .slidingSegmentPill:
            SlidingSegmentPillView(replayTrigger: replayTrigger)
        case .rollingCounter:
            RollingCounterView(replayTrigger: replayTrigger)
        case .progressiveButton:
            ProgressiveButtonView(replayTrigger: replayTrigger)
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(item: Catalog.all[0])
            .environmentObject(FavoritesStore())
    }
}

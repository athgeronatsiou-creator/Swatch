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

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                stageView
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 28))

                Text(instruction)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

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
    }

    @ViewBuilder
    private var stageView: some View {
        switch item.kind {
        case .pressScale:
            PressScaleView()
        case .toggleSwitch:
            ToggleSwitchView()
        case .likeBurst:
            LikeBurstView()
        case .drawnCheckmark:
            DrawnCheckmarkView()
        case .iconMorph:
            IconMorphView()
        case .slidingSegmentPill:
            SlidingSegmentPillView()
        case .rollingCounter:
            RollingCounterView()
        case .progressiveButton:
            ProgressiveButtonView()
        case .skeletonShimmer:
            SkeletonShimmerView()
        case .spinner:
            SpinnerView()
        case .progressBarFill:
            ProgressBarFillView()
        case .swipeToDelete:
            SwipeToDeleteView()
        case .pullToRefresh:
            PullToRefreshView()
        case .dragToReorder:
            DragToReorderView()
        case .modalPresentation:
            ModalPresentationView()
        case .sharedElementPush:
            SharedElementPushView()
        }
    }

    private var instruction: String {
        switch item.kind {
        case .pressScale: "Tap to press"
        case .toggleSwitch: "Tap to toggle"
        case .likeBurst: "Tap to like"
        case .drawnCheckmark: "Tap to check"
        case .iconMorph: "Tap to play"
        case .slidingSegmentPill: "Tap a segment to select"
        case .rollingCounter: "Tap to count"
        case .progressiveButton: "Tap to submit"
        case .skeletonShimmer: "Tap to simulate loading"
        case .spinner: "Tap to simulate loading"
        case .progressBarFill: "Tap to simulate loading"
        case .swipeToDelete: "Swipe left to delete"
        case .pullToRefresh: "Pull down to refresh"
        case .dragToReorder: "Drag a row to reorder"
        case .modalPresentation: "Tap to present"
        case .sharedElementPush: "Go back to watch it happen in reverse"
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(item: Catalog.all[0])
            .environmentObject(FavoritesStore())
    }
}

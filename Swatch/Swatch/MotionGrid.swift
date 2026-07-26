//
//  MotionGrid.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

/// The two-column card grid, shared by Library, Favourites and Search.
/// It owns the zoom-transition namespace and the push destination, so each screen
/// only has to decide *which* motions to show — otherwise the same grid plus the
/// same shared-element wiring would be copied three times.
struct MotionGrid: View {
    let items: [MotionItem]

    @EnvironmentObject private var favorites: FavoritesStore
    @Namespace private var zoomNamespace

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        MotionCardView(item: item, isFavorite: favorites.contains(item.id))
                    }
                    .buttonStyle(.plain)
                    .matchedTransitionSource(id: item.id, in: zoomNamespace)
                }
            }
            .padding()
        }
        .navigationDestination(for: MotionItem.self) { item in
            if item.kind == .sharedElementPush {
                DetailView(item: item)
                    .navigationTransition(.zoom(sourceID: item.id, in: zoomNamespace))
            } else {
                DetailView(item: item)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MotionGrid(items: Catalog.all)
            .environmentObject(FavoritesStore())
    }
}

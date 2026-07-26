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
///
/// Ordering and grouping live here for the same reason: all three screens should
/// present a given set of motions identically.
struct MotionGrid: View {
    let items: [MotionItem]

    @EnvironmentObject private var favorites: FavoritesStore
    @Namespace private var zoomNamespace

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var groups: [MotionCategoryGroup] {
        items.groupedByCategory
    }

    /// Headers only earn their space when the grid actually spans categories. Filtered
    /// to one, the chip row already says which — a single header repeating it is noise.
    /// Expressing it as "more than one group" rather than "is the All chip selected"
    /// means search results narrowing to one category get the same treatment for free.
    private var showsHeaders: Bool {
        groups.count > 1
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                if showsHeaders {
                    ForEach(groups) { group in
                        Section {
                            ForEach(group.items) { item in
                                card(item)
                            }
                        } header: {
                            header(group.category)
                        }
                    }
                } else {
                    // Still drawn from the groups, so the alphabetical-by-title order is
                    // the same rule in both branches rather than two that can drift.
                    ForEach(groups.flatMap(\.items)) { item in
                        card(item)
                    }
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

    private func card(_ item: MotionItem) -> some View {
        NavigationLink(value: item) {
            MotionCardView(item: item, isFavorite: favorites.contains(item.id))
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: item.id, in: zoomNamespace)
    }

    /// Deliberately not pinned: the chip row above is already a pinned glass bar, and a
    /// second sticky layer under it competes with it for the same edge.
    private func header(_ category: String) -> some View {
        Text(category.uppercased())
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        MotionGrid(items: Catalog.all)
            .environmentObject(FavoritesStore())
    }
}

//
//  FavouritesView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    @State private var selectedCategory: String?

    private var savedItems: [MotionItem] {
        Catalog.all.filter { favorites.contains($0.id) }
    }

    /// Chips here come from the saved subset, not the whole catalogue — a chip for
    /// a category you've saved nothing from would only ever show an empty grid.
    private var availableCategories: [String] {
        savedItems.distinctCategories
    }

    private var activeCategory: String? {
        availableCategories.resolving(selectedCategory)
    }

    var body: some View {
        NavigationStack {
            Group {
                if savedItems.isEmpty {
                    ContentUnavailableView(
                        "Nothing saved yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on any motion to keep it here.")
                    )
                } else {
                    MotionGrid(items: savedItems.matching(category: activeCategory))
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                if !savedItems.isEmpty {
                    CategoryFilterBar(
                        categories: availableCategories,
                        selection: Binding(
                            get: { activeCategory },
                            set: { selectedCategory = $0 }
                        )
                    )
                }
            }
            .navigationTitle("Favourites")
        }
    }
}

#Preview {
    FavouritesView()
        .environmentObject(FavoritesStore())
}

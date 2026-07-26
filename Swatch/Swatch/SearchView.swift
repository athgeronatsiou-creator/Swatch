//
//  SearchView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

/// Backs the search-role tab, so search is its own destination rather than a field
/// on each grid. It carries the category chips and an All/Saved scope so the two
/// F7 behaviours that were per-tab — filter composing with search, and searching
/// inside the favourited subset — still exist here.
struct SearchView: View {
    private enum Scope: String, CaseIterable {
        case all = "All"
        case saved = "Saved"
    }

    @EnvironmentObject private var favorites: FavoritesStore

    @State private var searchText = ""
    @State private var scope: Scope = .all
    @State private var selectedCategory: String?

    /// What this search runs against, before category or text narrowing.
    private var pool: [MotionItem] {
        switch scope {
        case .all: Catalog.all
        case .saved: Catalog.all.filter { favorites.contains($0.id) }
        }
    }

    private var availableCategories: [String] {
        pool.distinctCategories
    }

    private var activeCategory: String? {
        availableCategories.resolving(selectedCategory)
    }

    private var results: [MotionItem] {
        pool.matching(category: activeCategory, searchText: searchText)
    }

    var body: some View {
        NavigationStack {
            Group {
                if pool.isEmpty {
                    ContentUnavailableView(
                        "Nothing saved yet",
                        systemImage: "heart",
                        description: Text("Save a motion to search inside your favourites.")
                    )
                } else if results.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    MotionGrid(items: results)
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                if !pool.isEmpty {
                    CategoryFilterBar(
                        categories: availableCategories,
                        selection: Binding(
                            get: { activeCategory },
                            set: { selectedCategory = $0 }
                        )
                    )
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search motions")
            .textInputAutocapitalization(.never)
            .searchScopes($scope) {
                ForEach(Scope.allCases, id: \.self) { scope in
                    Text(scope.rawValue)
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(FavoritesStore())
}

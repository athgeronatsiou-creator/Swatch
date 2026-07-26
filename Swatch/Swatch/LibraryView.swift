//
//  LibraryView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct LibraryView: View {
    @State private var selectedCategory: String?

    var body: some View {
        NavigationStack {
            MotionGrid(items: Catalog.all.matching(category: selectedCategory))
                .safeAreaInset(edge: .top, spacing: 0) {
                    CategoryFilterBar(
                        categories: Catalog.all.distinctCategories,
                        selection: $selectedCategory
                    )
                }
                .navigationTitle("Library")
        }
    }
}

#Preview {
    LibraryView()
        .environmentObject(FavoritesStore())
}

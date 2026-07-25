//
//  LibraryView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Catalog.all) { item in
                        NavigationLink(value: item) {
                            MotionCardView(item: item, isFavorite: favorites.contains(item.id))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Library")
            .navigationDestination(for: MotionItem.self) { item in
                DetailView(item: item)
            }
        }
    }
}

#Preview {
    LibraryView()
        .environmentObject(FavoritesStore())
}

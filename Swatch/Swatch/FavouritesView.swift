//
//  FavouritesView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var savedItems: [MotionItem] {
        Catalog.all.filter { favorites.contains($0.id) }
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
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(savedItems) { item in
                                NavigationLink(value: item) {
                                    MotionCardView(item: item, isFavorite: true)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationDestination(for: MotionItem.self) { item in
                DetailView(item: item)
            }
        }
    }
}

#Preview {
    FavouritesView()
        .environmentObject(FavoritesStore())
}

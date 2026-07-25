//
//  LibraryView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var favorites: FavoritesStore
    @Namespace private var zoomNamespace

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
                        .matchedTransitionSource(id: item.id, in: zoomNamespace)
                    }
                }
                .padding()
            }
            .navigationTitle("Library")
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
}

#Preview {
    LibraryView()
        .environmentObject(FavoritesStore())
}

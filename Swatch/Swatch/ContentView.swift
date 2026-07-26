//
//  ContentView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var favorites = FavoritesStore()

    var body: some View {
        TabView {
            Tab("Library", systemImage: "square.grid.2x2") {
                LibraryView()
            }
            Tab("Favourites", systemImage: "heart") {
                FavouritesView()
            }
            // The search role is what puts the button at the trailing end of the
            // tab bar, detached from the pill, and morphs the bar into a search
            // field on tap. Placement and styling are the system's, not ours.
            Tab(role: .search) {
                SearchView()
            }
        }
        .environmentObject(favorites)
    }
}

#Preview {
    ContentView()
}

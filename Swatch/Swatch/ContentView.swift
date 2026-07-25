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
        }
        .environmentObject(favorites)
    }
}

#Preview {
    ContentView()
}

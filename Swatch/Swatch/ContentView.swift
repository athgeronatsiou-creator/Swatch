//
//  ContentView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "heart")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hey girlies!")

                NavigationLink("View Detail", destination: DetailView())
            }
            .padding(30)
        }
    }
}

#Preview {
    ContentView()
}

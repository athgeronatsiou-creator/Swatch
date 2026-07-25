//
//  DragToReorderView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct DragToReorderView: View {
    @State private var items = ["Frame", "Shadow", "Blur", "Glow"]

    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
            .onMove(perform: move)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, .constant(.active))
        .sensoryFeedback(.selection, trigger: items)
    }

    private func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    DragToReorderView()
}

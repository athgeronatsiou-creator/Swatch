//
//  PullToRefreshView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct PullToRefreshView: View {
    @State private var refreshCount = 0

    var body: some View {
        List {
            ForEach(0..<4, id: \.self) { index in
                Label("Item \(index + 1)", systemImage: "doc.text")
            }

            Text(refreshCount == 0 ? "Pull down to refresh" : "Refreshed \(refreshCount)×")
                .font(.caption)
                .foregroundStyle(.secondary)
                .contentTransition(.numericText())
                .animation(Motion.refreshContentUpdate, value: refreshCount)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .refreshable {
            try? await Task.sleep(for: .milliseconds(1200))
            refreshCount += 1
        }
        .sensoryFeedback(.success, trigger: refreshCount)
    }
}

#Preview {
    PullToRefreshView()
}

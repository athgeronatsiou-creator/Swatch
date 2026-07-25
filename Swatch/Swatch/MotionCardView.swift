//
//  MotionCardView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct MotionCardView: View {
    let item: MotionItem
    let isFavorite: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.accentColor.opacity(0.12))
                    .aspectRatio(4 / 3, contentMode: .fit)
                    .overlay {
                        Image(systemName: item.symbolName)
                            .font(.system(size: 32))
                            .foregroundStyle(.tint)
                    }

                if isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(8)
                }
            }

            Text(item.title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(item.category)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

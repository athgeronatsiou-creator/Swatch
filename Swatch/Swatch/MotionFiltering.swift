//
//  MotionFiltering.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

// Filter + search rules shared by the Library and Favourites grids (F7).
// They live here rather than in either screen so the two can't drift apart —
// Favourites applies the same rules, just to the favourited subset.
extension Collection where Element == MotionItem {
    /// Distinct categories, in catalogue order. Derived from the items themselves,
    /// so adding a Catalog entry with a brand-new category makes its chip appear
    /// with no change here or in either screen.
    var distinctCategories: [String] {
        var seen: Set<String> = []
        return reduce(into: [String]()) { result, item in
            if seen.insert(item.category).inserted { result.append(item.category) }
        }
    }

    /// Category filter and text search compose — an item has to satisfy both.
    /// `category == nil` means "All"; blank `searchText` means "no search".
    /// Search matches title *or* category, so "gesture" surfaces the whole category.
    func matching(category: String?, searchText: String = "") -> [MotionItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return filter { item in
            guard category == nil || item.category == category else { return false }
            guard !query.isEmpty else { return true }
            return item.title.localizedCaseInsensitiveContains(query)
                || item.category.localizedCaseInsensitiveContains(query)
        }
    }
}

extension Array where Element == String {
    /// `selection` if it's still one of these categories, otherwise nil — "All".
    /// Favourites and Search both build their chips from a subset that can shrink
    /// underneath them: un-favourite the last Gesture motion, or switch the search
    /// scope to Saved, and the chip you're filtered by can disappear. Falling back
    /// to All keeps the chips and the grid from ever disagreeing.
    func resolving(_ selection: String?) -> String? {
        guard let selection, contains(selection) else { return nil }
        return selection
    }
}

/// Horizontal row of category chips. `selection == nil` is "All".
struct CategoryFilterBar: View {
    let categories: [String]
    @Binding var selection: String?

    var body: some View {
        ScrollView(.horizontal) {
            GlassEffectContainer {
                HStack(spacing: 8) {
                    chip("All", isSelected: selection == nil) { selection = nil }

                    ForEach(categories, id: \.self) { category in
                        chip(category, isSelected: selection == category) {
                            // Tapping the active chip again clears back to All.
                            selection = selection == category ? nil : category
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
        .scrollIndicators(.hidden)
        .sensoryFeedback(.selection, trigger: selection)
    }

    private func chip(
        _ title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .glassEffect(
                    isSelected
                        ? .regular.tint(.accentColor).interactive()
                        : .regular.interactive(),
                    in: .capsule
                )
        }
        .buttonStyle(.plain)
        // Same curve as the sliding segment pill — this is the same idea of a
        // selection moving between segments, so it should read the same way.
        .animation(Motion.segmentSlide, value: isSelected)
    }
}

#Preview {
    @Previewable @State var selection: String?

    return CategoryFilterBar(
        categories: Catalog.all.distinctCategories,
        selection: $selection
    )
}

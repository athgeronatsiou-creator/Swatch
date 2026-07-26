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
/// One category's worth of a grid, so the grid can draw a header above its items.
struct MotionCategoryGroup: Identifiable {
    let category: String
    let items: [MotionItem]

    var id: String { category }
}

extension Collection where Element == MotionItem {
    /// Distinct categories, alphabetical. Derived from the items themselves, so adding
    /// a Catalog entry with a brand-new category makes its chip appear, in the right
    /// place, with no change here or in any screen.
    ///
    /// Sorted with `localizedStandardCompare` rather than `<` so the order matches what
    /// the person reading it would call alphabetical, in their locale, rather than
    /// Unicode code-point order.
    var distinctCategories: [String] {
        Set(map(\.category))
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    /// Grouped into alphabetical category sections, each section's items alphabetical
    /// by title. Same ordering rule as the chips, so the chip row and the grid read as
    /// one list rather than two — which is the whole point of sorting either of them.
    var groupedByCategory: [MotionCategoryGroup] {
        Dictionary(grouping: self, by: \.category)
            .map { category, items in
                MotionCategoryGroup(
                    category: category,
                    items: items.sorted {
                        $0.title.localizedStandardCompare($1.title) == .orderedAscending
                    }
                )
            }
            .sorted { $0.category.localizedStandardCompare($1.category) == .orderedAscending }
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

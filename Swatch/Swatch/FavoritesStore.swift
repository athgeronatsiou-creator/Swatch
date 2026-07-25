//
//  FavoritesStore.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import Combine
import Foundation

final class FavoritesStore: ObservableObject {
    private static let key = "favoriteMotionIDs"

    @Published private(set) var ids: Set<String>

    init() {
        ids = Set(UserDefaults.standard.stringArray(forKey: Self.key) ?? [])
    }

    func contains(_ id: String) -> Bool {
        ids.contains(id)
    }

    func toggle(_ id: String) {
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        UserDefaults.standard.set(Array(ids), forKey: Self.key)
    }
}

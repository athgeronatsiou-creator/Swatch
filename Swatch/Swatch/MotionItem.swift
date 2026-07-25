//
//  MotionItem.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct MotionItem: Identifiable, Hashable {
    let id: String
    let title: String
    let category: String
    let symbolName: String
    let description: String
    let conceptNote: String
    let stage: (_ replayTrigger: Int) -> AnyView

    static func == (lhs: MotionItem, rhs: MotionItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

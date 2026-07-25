//
//  RollingCounterView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct RollingCounterView: View {
    @State private var count = 0

    var body: some View {
        Text("\(count)")
            .font(.system(size: 60, weight: .bold, design: .rounded))
            .foregroundStyle(.tint)
            .contentTransition(.numericText())
            .onTapGesture { play() }
    }

    private func play() {
        withAnimation(Motion.counterRoll) {
            count += Int.random(in: 3...9)
        }
    }
}

#Preview {
    RollingCounterView()
}

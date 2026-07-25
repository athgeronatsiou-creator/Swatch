//
//  ToggleSwitchView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct ToggleSwitchView: View {
    var replayTrigger: Int = 0
    @State private var isOn = false

    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(isOn ? Color.green : Color(.systemGray4))
                .frame(width: 51, height: 31)

            Circle()
                .fill(.white)
                .padding(2)
                .shadow(radius: 1)
        }
        .frame(width: 51, height: 31)
        .onChange(of: replayTrigger) { _, _ in play() }
    }

    private func play() {
        isOn = false
        withAnimation(Motion.toggleSwitch) {
            isOn = true
        }
    }
}

#Preview {
    ToggleSwitchView()
}

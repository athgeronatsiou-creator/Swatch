//
//  DrawnCheckmarkView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

private struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.18, y: rect.minY + rect.height * 0.55))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.42, y: rect.minY + rect.height * 0.78))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.85, y: rect.minY + rect.height * 0.25))
        return path
    }
}

struct DrawnCheckmarkView: View {
    var replayTrigger: Int = 0
    @State private var trimEnd = 0.0
    @State private var scale = 1.0

    var body: some View {
        CheckmarkShape()
            .trim(from: 0, to: trimEnd)
            .stroke(.tint, style: StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round))
            .frame(width: 80, height: 80)
            .scaleEffect(scale)
            .onChange(of: replayTrigger) { _, _ in play() }
    }

    private func play() {
        trimEnd = 0
        scale = 1
        withAnimation(Motion.checkmarkDraw) {
            trimEnd = 1
        } completion: {
            scale = 1.2
            withAnimation(Motion.checkmarkSettle) {
                scale = 1
            }
        }
    }
}

#Preview {
    DrawnCheckmarkView()
}

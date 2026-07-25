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
    @State private var trimEnd = 0.0
    @State private var scale = 1.0

    var body: some View {
        ZStack {
            CheckmarkShape()
                .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round))

            CheckmarkShape()
                .trim(from: 0, to: trimEnd)
                .stroke(.tint, style: StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round))
        }
        .frame(width: 80, height: 80)
        .scaleEffect(scale)
        .contentShape(Rectangle())
        .onTapGesture { play() }
        .sensoryFeedback(trigger: trimEnd) { _, newValue in
            newValue == 1 ? .success : nil
        }
    }

    private func play() {
        guard trimEnd == 0 else { return }
        withAnimation(Motion.checkmarkDraw) {
            trimEnd = 1
        } completion: {
            scale = 1.2
            withAnimation(Motion.checkmarkSettle) {
                scale = 1
            }
            Task {
                try? await Task.sleep(for: .milliseconds(900))
                withAnimation(Motion.checkmarkDraw) {
                    trimEnd = 0
                }
            }
        }
    }
}

#Preview {
    DrawnCheckmarkView()
}

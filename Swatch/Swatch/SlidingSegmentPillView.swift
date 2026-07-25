//
//  SlidingSegmentPillView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 25/7/26.
//

import SwiftUI

struct SlidingSegmentPillView: View {
    var replayTrigger: Int = 0
    @State private var selection = 0
    @Namespace private var namespace

    private let segments = ["A", "B", "C"]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(segments.indices, id: \.self) { index in
                Text(segments[index])
                    .font(.headline)
                    .foregroundStyle(selection == index ? .white : .primary)
                    .frame(width: 44, height: 36)
                    .background {
                        if selection == index {
                            Capsule()
                                .fill(.tint)
                                .matchedGeometryEffect(id: "pill", in: namespace)
                        }
                    }
            }
        }
        .padding(4)
        .background(Color(.systemGray5), in: Capsule())
        .onChange(of: replayTrigger) { _, _ in play() }
    }

    private func play() {
        withAnimation(Motion.segmentSlide) {
            selection = (selection + 1) % segments.count
        }
    }
}

#Preview {
    SlidingSegmentPillView()
}

//
//  ModalPresentationView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

private struct ModalContent: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.on.square")
                .font(.system(size: 48))
                .foregroundStyle(.tint)
            Text("A modal, presented")
                .font(.title3.bold())
            Text("Content fades and scales in once the sheet settles, instead of appearing instantly.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Dismiss") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding(32)
        .scaleEffect(isVisible ? 1 : 0.85)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(Motion.modalContentReveal) {
                isVisible = true
            }
        }
    }
}

struct ModalPresentationView: View {
    @State private var isPresented = false

    var body: some View {
        Button {
            isPresented = true
        } label: {
            Label("Show details", systemImage: "square.on.square")
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }
        .glassEffect()
        .sheet(isPresented: $isPresented) {
            ModalContent()
                .presentationDetents([.medium])
                .presentationCornerRadius(32)
        }
        .sensoryFeedback(trigger: isPresented) { _, newValue in
            newValue ? .impact(weight: .light) : nil
        }
    }
}

#Preview {
    ModalPresentationView()
}

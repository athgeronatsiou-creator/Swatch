//
//  SharedElementPushView.swift
//  Swatch
//
//  Created by Athina Geronatsiou on 26/7/26.
//

import SwiftUI

struct SharedElementPushView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.accentColor.opacity(0.12))
            .frame(width: 160, height: 120)
            .overlay {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)
            }
    }
}

#Preview {
    SharedElementPushView()
}

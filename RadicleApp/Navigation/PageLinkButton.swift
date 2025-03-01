//
//  PageLinkButton.swift
//  RadicleApp
//
//  Created by bordumb on 26/02/2025.
//

import SwiftUI

struct PageLinkButton: View {
    var URL: String
    @State private var isCopied: Bool = false

    var body: some View {
        Button(action: {
            UIPasteboard.general.string = URL
            withAnimation(.easeInOut(duration: 0.2)) {
                isCopied = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCopied = false
                }
            }
        }) {
            ZStack {
                // Background rectangle stays the same size
                Rectangle()
                    .fill(Color.backgroundDefault)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Rectangle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Border
                    )

                // Icon changes size and color dynamically
                Icon(
                    name: .copyLink,
                    size: isCopied ? 19.2 : 16, // 20% increase in size
                    color: isCopied ? .blue : .white
                )
            }
        }
    }
}

#Preview {
    PageLinkButton(URL: "www.apple.com")
}

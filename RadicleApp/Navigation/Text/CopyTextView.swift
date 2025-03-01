//
//  CopyTextView.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import SwiftUI

struct CopyTextView: View {
    let fullText: String  // Full connection string for copying
    let displayText: String  // Shortened version for UI
    @State private var copied = false  // Tracks copy state
    @State private var textSize: CGSize = .zero  // Tracks text size dynamically

    var body: some View {
        HStack {
            Text(copied ? paddedCopiedText() : displayText)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(copied ? .green : .blue)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                textSize = geometry.size  // Capture text size dynamically
                            }
                    }
                )
                .frame(minHeight: textSize.height)  // Prevents vertical movement
                .lineLimit(2)  // Ensures it always takes two lines if needed
                .multilineTextAlignment(.leading)
                .onTapGesture {
                    UIPasteboard.general.string = fullText  // Copy full string
                    copied = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        copied = false
                    }
                }
                .animation(.easeInOut, value: copied)
        }
    }

    // Ensures "Copied!" maintains the same vertical space
    private func paddedCopiedText() -> String {
        let padding = String(repeating: "\u{00A0}", count: max(0, displayText.count - 8))
        return "Copied! \(padding)"
    }
}




#Preview {
    CopyTextView(
        fullText: "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776",
        displayText: "z6MkrL...cNYPm7@seed.radicle.garden:8776"
    )
}


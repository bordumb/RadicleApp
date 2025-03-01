//
//  FancyCard.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import SwiftUI

struct FancyCard: View {
    var body: some View {
        ZStack {
            // Background card with shadow
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 300, height: 250)
                .foregroundStyle(.black)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
            
            // Border with blue gradient
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .blue.opacity(0.01), .blue, .blue, .blue.opacity(0.01)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 3
                )
                .frame(width: 300, height: 250)
            
            // Text
            Text("CARD")
                .bold()
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}


#Preview {
    FancyCard()
}

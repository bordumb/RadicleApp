//
//  TopNavigationBar.swift
//  RadicleApp
//
//  Created by bordumb on 22/02/2025.
//

import SwiftUI

struct TopNavigationBar: View {
    // We point to the same key in AppStorage
    @AppStorage("selectedServer") private var selectedServer = "seed.radicle.xyz"

    var body: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: ContentView()) {
                Image("home_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }

            Text(selectedServer)  // Show the selected node
                .foregroundColor(.blue)
                .font(.headline)

            Spacer()

            Image(systemName: "person.crop.circle")
                .foregroundColor(.white)
                .font(.title2)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(Color.black)
    }
}

#Preview {
    NavigationStack {
        TopNavigationBar()
    }
}


//
//  TopNavigationBar.swift
//  RadicleApp
//
//  Created by bordumb on 22/02/2025.
//

import SwiftUI

struct TopNavigationBar: View {
    @AppStorage("selectedServer") private var selectedServer = "seed.radicle.xyz"
    @Environment(\.presentationMode) var presentationMode  // Detects navigation state

    var body: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: ContentView()) {
                Image("home_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }

            // Dynamically check if RepositoryListView is active
            Text(isOnRepositoryListView() ? "Radicle" : selectedServer)
                .foregroundColor(.blue)
                .font(.headline)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(Color.black)
    }

    // Checks if RepositoryListView is the active screen
    private func isOnRepositoryListView() -> Bool {
        guard let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first(where: { $0.isKeyWindow }) else {
            return false
        }

        return keyWindow.rootViewController?.children.contains(where: { viewController in
            String(describing: type(of: viewController)) == "UIHostingController<RepositoryListView>"
        }) ?? false
    }
}

#Preview {
    NavigationStack {
        TopNavigationBar()  // Test different pages
    }
}

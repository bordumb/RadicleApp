//
//  SettingsView.swift
//  RadicleApp
//
//  Created by bordumb on 22/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedServer") private var selectedServer: String = "seed.radicle.garden"
    @ObservedObject var apiClient = APIClient.shared  // Observe APIClient updates

    private let serverOptions = [
        "seed.radicle.garden",
        "ash.radicle.garden",
        "seed.radicle.xyz"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Node").foregroundColor(.white)) {
                    Picker("Select Node", selection: $selectedServer) {
                        ForEach(serverOptions, id: \.self) { server in
                            Text(server)
                                .foregroundColor(.white) // Ensures the picker's row text is white
                                .tag(server)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section {
                    Button("Test API Fetch") {
                        Task {
                            await reloadAPI()
                        }
                    }
                }
                .foregroundColor(.white) // The section button text
            }
            .scrollContentBackground(.hidden) // Hides the default background of the Form
            .background(Color.black)          // Black background for the Form
            .navigationTitle("Settings")
            // Use a white tint so buttons, pickers, etc., appear in a contrasting color
            .tint(.white)
        }
        // Force dark mode, which aligns nicely with a black background + white text
        .preferredColorScheme(.dark)
    }

    private func reloadAPI() async {
        do {
            let repositories: [RepoItem] = try await apiClient.fetch(endpoint: "repos")
            print("✅ API Fetch Success: \(repositories.count) repositories")
        } catch {
            print("❌ API Fetch Failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SettingsView()
}


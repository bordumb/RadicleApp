//
//  ServerSelectorView.swift
//  RadicleApp
//
//  Created by bordumb on 22/02/2025.
//



import SwiftUI

struct NodeSelectorView: View {
    @AppStorage("selectedServer") private var selectedServer: String = "seed.radicle.xyz"
    @ObservedObject var apiClient = APIClient.shared  // Observe APIClient updates

    private let serverOptions = [
        "seed.radicle.garden",
        "ash.radicle.garden",
        "seed.radicle.xyz"
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Node")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Picker("Select Server", selection: $selectedServer) {
                ForEach(serverOptions, id: \.self) { server in
                    Text(server).tag(server)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 250)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .onChange(of: selectedServer) { newValue in
                UserDefaults.standard.setValue(newValue, forKey: "selectedServer")
                print("🌍 Server Changed to: \(newValue)")
                Task {
                    await reloadAPI()
                }
            }

            Text("Current API URL:")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(apiClient.baseURL)
                .font(.callout)
                .bold()
                .foregroundColor(.blue)
        }
        .padding()
        .frame(width: 300)
        .background(Color.black.opacity(0.8))
        .cornerRadius(15)
        .shadow(radius: 10)
    }

    private func reloadAPI() async {
        do {
            let repositories: [RepoItem] = try await apiClient.fetch(endpoint: "repos")
            print("✅ API Fetch Success: \(repositories)")
        } catch {
            print("❌ API Fetch Failed: \(error)")
        }
    }
}

#Preview {
    NodeSelectorView()
}


//
//  ServerSelectorView.swift
//  RadicleApp
//
//  Created by bordumb on 22/02/2025.
//



import SwiftUI

struct ServerSelectorView: View {
    @AppStorage("selectedServer") private var selectedServer: String = "seed.radicle.garden"
    @ObservedObject var apiClient = APIClient.shared  // Observe APIClient updates

    private let serverOptions = [
        "seed.radicle.garden",
        "ash.radicle.garden",
        "seed.radicle.garden"
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


//struct ServerSelectorView: View {
//    @AppStorage("selectedServer") private var selectedServer: String = "seed.radicle.garden"
//    @ObservedObject var apiClient = APIClient.shared
//
//    private let serverOptions = [
//        "seed.radicle.garden",
//        "ash.radicle.garden",
//        "seed.radicle.garden"
//    ]
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Select Node")
//                .font(.title2)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//
//            // Server Picker
//            Picker("Select Server", selection: $selectedServer) {
//                ForEach(serverOptions, id: \.self) { server in
//                    Text(server).tag(server)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            .frame(width: 250)
//            .padding()
//            .background(Color.gray.opacity(0.2))
//            .cornerRadius(10)
//            .onChange(of: selectedServer) { newValue in
//                UserDefaults.standard.setValue(newValue, forKey: "selectedServer")
//                print("🌍 Server Changed to: \(newValue)")
//                Task {
//                    await reloadAPI()
//                }
//            }
//
//            // Current API URL Display
//            Text("Current API URL:")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text(apiClient.baseURL)
//                .font(.callout)
//                .bold()
//                .foregroundColor(.blue)
//        }
//        .padding()
//        .frame(width: 300)
//        .background(Color.black.opacity(0.8))
//        .cornerRadius(15)
//        .shadow(radius: 10)
//    }
//
//    private func reloadAPI() async {
//        do {
//            // Since "health" doesn't exist, we just check if the base URL responds
//            let testURL = apiClient.baseURL
//            let url = URL(string: testURL)!
//
//            print("🌍 Pinging API Base URL: \(testURL)")
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            // Check if the response is a valid HTTP response
//            if let httpResponse = response as? HTTPURLResponse {
//                print("📡 API Response Code: \(httpResponse.statusCode)")
//
//                if httpResponse.statusCode == 404 {
//                    print("❌ API Base URL Not Found (404)")
//                    return
//                }
//            }
//
//            // Check if response is empty
//            guard !data.isEmpty else {
//                print("⚠️ API Base URL returned empty response")
//                return
//            }
//
//            // Try to parse the response as JSON (optional)
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                print("✅ API Base URL is reachable: \(json)")
//            } else {
//                print("✅ API Base URL is reachable (non-JSON response)")
//            }
//
//        } catch {
//            print("❌ API Base URL Check Failed: \(error)")
//        }
//    }
//}

#Preview {
    ServerSelectorView()
}


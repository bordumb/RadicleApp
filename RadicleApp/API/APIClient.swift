//
//  APIClient.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

//import Foundation
//import SwiftUI
//
//enum APIError: Error {
//    case invalidURL
//    case noData
//    case decodingError(Error)
//    case invalidResponse
//}
//
//protocol APIClientProtocol {
//    func fetch<T: Decodable>(endpoint: String) async throws -> T
//}
//
//class APIClient: APIClientProtocol {
//    static let shared = APIClient()
//    private init() {}
//
//    private let cache = CacheManager.shared
//    
//    private var baseURL: String {
//        let selectedServer = UserDefaults.standard.string(forKey: "selectedServer") ?? "seed.radicle.garden"
//        return "https://\(selectedServer)/api/v1/"
//    }
//
//    func fetch<T: Decodable>(endpoint: String) async throws -> T {
//        let urlString = baseURL + endpoint
//        guard let url = URL(string: urlString) else {
//            throw URLError(.badURL)
//        }
//
//        print("🌍 API Request: \(urlString)") // Debugging
//        let request = URLRequest(url: url)
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            // Print HTTP Response
//            if let httpResponse = response as? HTTPURLResponse {
//                print("📡 API Response Code: \(httpResponse.statusCode)")
//            }
//
//            // Print Raw Response Data
//            if let rawResponse = String(data: data, encoding: .utf8) {
//                print("📩 API Response Data: \(rawResponse)")
//            }
//
//            return try JSONDecoder().decode(T.self, from: data)
//        } catch {
//            print("🚨 Network Request Failed: \(error.localizedDescription)")
//            throw error
//        }
//    }
//}


//
//  APIClient.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation
import SwiftUI
import Combine

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case invalidResponse
}

protocol APIClientProtocol {
    func fetch<T: Decodable>(endpoint: String) async throws -> T
}

class APIClient: ObservableObject, APIClientProtocol {
    static let shared = APIClient()

    @Published private(set) var baseURL: String

    private var cancellables = Set<AnyCancellable>()

    private init() {
        let selectedServer = UserDefaults.standard.string(forKey: "selectedServer") ?? "seed.radicle.garden"
        self.baseURL = "https://\(selectedServer)/api/v1"  // No trailing slash

        // Observe changes to selectedServer and update baseURL
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let updatedServer = UserDefaults.standard.string(forKey: "selectedServer") ?? "seed.radicle.garden"
                self.baseURL = "https://\(updatedServer)/api/v1"
                print("🔄 Updated API Base URL: \(self.baseURL)")
            }
            .store(in: &cancellables)
    }

    func fetch<T: Decodable>(endpoint: String) async throws -> T {
        let urlString = baseURL + (endpoint.hasPrefix("/") ? endpoint : "/\(endpoint)") // Ensure proper URL format
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        print("🌍 API Request: \(urlString)") // Debugging
        let request = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Print HTTP Response
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 API Response Code: \(httpResponse.statusCode)")

                if httpResponse.statusCode == 404 {
                    print("❌ API Endpoint Not Found (404)")
                    throw APIError.invalidResponse
                }
            }

            // Check if response is empty
            guard !data.isEmpty else {
                print("⚠️ API Response is empty")
                throw APIError.noData
            }

            // Print Raw Response Data
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("📩 API Response Data: \(rawResponse)")
            }

            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            print("🚨 JSON Decoding Failed: \(decodingError)")
            throw APIError.decodingError(decodingError)
        } catch {
            print("🚨 Network Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
}


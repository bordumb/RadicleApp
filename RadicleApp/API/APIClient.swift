//
//  APIClient.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case invalidResponse
}

protocol APIClientProtocol {
    func fetch<T: Decodable>(endpoint: String) async throws -> T
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    private init() {}

    private let cache = CacheManager.shared
    
    func fetch<T: Decodable>(endpoint: String) async throws -> T {
        let baseURL = "https://seed.radicle.garden/api/v1/"
        let urlString = baseURL + endpoint
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        print("🌍 API Request: \(urlString)") // Debugging
        let request = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Print HTTP Response
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 API Response Code: \(httpResponse.statusCode)")
            }

            // Print Raw Response Data
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("📩 API Response Data: \(rawResponse)")
            }

            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("🚨 Network Request Failed: \(error.localizedDescription)")
            throw error
        }
    }


//    func fetch<T: Decodable>(endpoint: String) async throws -> T {
//        guard let url = URL(string: baseURL + endpoint) else {
//            throw APIError.invalidURL
//        }
//
//        if let cachedData = cache.getData(forKey: endpoint),
//           let cachedObject = try? JSONDecoder().decode(T.self, from: cachedData) {
//            return cachedObject
//        }
//
//        let request = URLRequest(url: url)
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            throw APIError.invalidResponse
//        }
//
//        do {
//            let decodedObject = try JSONDecoder().decode(T.self, from: data)
//            cache.storeData(data, forKey: endpoint)
//            return decodedObject
//        } catch {
//            throw APIError.decodingError(error)
//        }
//    }
}


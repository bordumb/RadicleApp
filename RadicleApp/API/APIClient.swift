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

    private let baseURL = "https://seed.radicle.xyz/api/v1/"
    private let cache = CacheManager.shared

    func fetch<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        if let cachedData = cache.getData(forKey: endpoint),
           let cachedObject = try? JSONDecoder().decode(T.self, from: cachedData) {
            return cachedObject
        }

        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            cache.storeData(data, forKey: endpoint)
            return decodedObject
        } catch {
            throw APIError.decodingError(error)
        }
    }
}


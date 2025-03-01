//
//  NodeService.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import Foundation

protocol NodeServiceProtocol {
    func fetchNodeInfo() async throws -> NodeInfo
}

class NodeService: NodeServiceProtocol {
    static let shared = NodeService()
    private init() {}

    func fetchNodeInfo() async throws -> NodeInfo {
        print("🌍 [NodeService] Fetching node info...")

        do {
            let nodeInfo: NodeInfo = try await APIClient.shared.fetch(endpoint: "node")
            print("✅ [NodeService] Successfully fetched node info: \(nodeInfo.id)")
            return nodeInfo
        } catch let decodingError as DecodingError {
            print("🚨 [NodeService] JSON Decoding Failed: \(decodingError.localizedDescription)")
            throw APIError.decodingError(decodingError)
        } catch {
            print("❌ [NodeService] Failed to fetch node info: \(error.localizedDescription)")
            throw error
        }
    }
}


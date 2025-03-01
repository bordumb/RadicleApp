//
//  RepositoryService.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

protocol RepositoryServiceProtocol {
    func fetchRepositories() async throws -> [RepoItem]
    func fetchRepositoryDetails(rid: String) async throws -> RepoItem
    func fetchRemotes(rid: String) async throws -> [Remote]
    func fetchActivity(rid: String) async throws -> [Int]
}

class RepositoryService: RepositoryServiceProtocol {
    static let shared = RepositoryService()
    private init() {}

    func fetchRepositories() async throws -> [RepoItem] {
        return try await APIClient.shared.fetch(endpoint: "repos")
    }

    func fetchRepositoryDetails(rid: String) async throws -> RepoItem {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)")
    }

    func fetchRemotes(rid: String) async throws -> [Remote] {
        print("➜ Starting fetchRemotes for RID: \(rid)")
        let startTime = Date()
        
        do {
            let remotes = try await APIClient.shared.fetch(endpoint: "repos/\(rid)/remotes") as [Remote]
            let elapsed = Date().timeIntervalSince(startTime)
            
            print("✅ fetchRemotes succeeded in \(String(format: "%.2f", elapsed))s for RID \(rid)")
            print("   Remotes response:\n\(remotes)\n")
            return remotes
            
        } catch {
            let elapsed = Date().timeIntervalSince(startTime)
            print("❌ fetchRemotes failed in \(String(format: "%.2f", elapsed))s for RID \(rid)")
            print("   Error: \(error)\n")
            throw error
        }
    }


    func fetchActivity(rid: String) async throws -> [Int] {
        let response: ActivityResponse = try await APIClient.shared.fetch(endpoint: "repos/\(rid)/activity")
        return response.activity
    }
}

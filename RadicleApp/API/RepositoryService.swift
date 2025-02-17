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
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/remotes")
    }

    func fetchActivity(rid: String) async throws -> [Int] {
        let response: ActivityResponse = try await APIClient.shared.fetch(endpoint: "repos/\(rid)/activity")
        return response.activity
    }
}

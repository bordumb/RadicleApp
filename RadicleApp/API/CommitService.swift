//
//  CommitService.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

protocol CommitServiceProtocol {
    func fetchCommits(rid: String) async throws -> [CommitResponse]
    func fetchCommitDetails(rid: String, commit: String) async throws -> CommitResponse
    func fetchDiff(rid: String, base: String, oid: String) async throws -> DiffResponse
}

class CommitService: CommitServiceProtocol {
    static let shared = CommitService()
    private init() {}

    func fetchCommits(rid: String) async throws -> [CommitResponse] {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/commits")
    }

    func fetchCommitDetails(rid: String, commit: String) async throws -> CommitResponse {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/commits/\(commit)")
    }

    func fetchDiff(rid: String, base: String, oid: String) async throws -> DiffResponse {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/diff/\(base)/\(oid)")
    }
}

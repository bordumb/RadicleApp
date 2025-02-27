//
//  CommitService.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

protocol CommitServiceProtocol {
    func fetchCommits(rid: String) async throws -> [CommitResponse]
    func fetchCommitDetails(rid: String, commit: String, nextPage: String?) async throws -> CommitDetailsResponse
    func fetchDiff(rid: String, base: String, oid: String) async throws -> DiffResponse
}

class CommitService: CommitServiceProtocol {
    static let shared = CommitService()
    private init() {}

    func fetchCommits(rid: String) async throws -> [CommitResponse] {
        let commits: [CommitResponse] = try await APIClient.shared.fetch(endpoint: "repos/\(rid)/commits")

        // Debug print the total number of commits fetched
        print("Fetched \(commits.count) commits for repository: \(rid)")

        // Debug print the latest commit ID and timestamp
        if let latestCommit = commits.first {
            print("Latest Commit ID: \(latestCommit.id), Time: \(latestCommit.committer.time)")
        }

        // Debug print details of all commits
        for commit in commits {
            print("Commit ID: \(commit.id)")
            print("Author: \(commit.author.name) (\(commit.author.email))")
            print("Summary: \(commit.summary)")
            print("Commit Time: \(commit.committer.time)")
            print("-------------------------------")
        }

        return commits
    }


    /// Fetch commit details, with optional pagination
    func fetchCommitDetails(rid: String, commit: String, nextPage: String? = nil) async throws -> CommitDetailsResponse {
        let endpoint = nextPage ?? "repos/\(rid)/commits/\(commit)" // Use `nextPage` if provided
        return try await APIClient.shared.fetch(endpoint: endpoint)
    }

    func fetchDiff(rid: String, base: String, oid: String) async throws -> DiffResponse {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/diff/\(base)/\(oid)")
    }
}

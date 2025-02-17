//
//  FileService.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

protocol FileServiceProtocol {
//    func fetchFileTree(rid: String, sha: String) async throws -> [File]
//    func fetchFile(rid: String, sha: String, path: String) async throws -> File
    func fetchReadme(rid: String) async throws -> ReadmeResponse
}

class FileService: FileServiceProtocol {
    static let shared = FileService()
    private init() {}

//    func fetchFileTree(rid: String, sha: String) async throws -> [File] {
//        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/tree/\(sha)")
//    }
//
//    func fetchFile(rid: String, sha: String, path: String) async throws -> File {
//        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/blob/\(sha)/\(path)")
//    }

    func fetchReadme(rid: String) async throws -> ReadmeResponse {
        let latestCommitSHA = try await fetchLatestCommitSHA(rid: rid)
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/readme/\(latestCommitSHA)")
    }

    private func fetchLatestCommitSHA(rid: String) async throws -> String {
        let commits = try await CommitService.shared.fetchCommits(rid: rid)

        guard let latestCommit = commits.sorted(by: { $0.commit.committer.time > $1.commit.committer.time }).first else {
            throw NSError(domain: "FileServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No commits found"])
        }

        return latestCommit.commit.id
    }
}

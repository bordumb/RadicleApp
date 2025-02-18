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

        // Specify the expected return type explicitly
        let readmeResponse: ReadmeResponse = try await APIClient.shared.fetch(endpoint: "repos/\(rid)/readme/\(latestCommitSHA)")

        // Decode Base64 if content is a Base64-encoded string
        if let decodedData = Data(base64Encoded: readmeResponse.content),
           let readmeContent = String(data: decodedData, encoding: .utf8) {
            print("README Content:\n\(readmeContent)")
        } else {
            print("Failed to decode README content")
        }

        return readmeResponse
    }
    
    private func fetchLatestCommitSHA(rid: String) async throws -> String {
        let commits = try await CommitService.shared.fetchCommits(rid: rid)

        // Debug print all commit SHAs and timestamps
        print("Fetched \(commits.count) commits for repository: \(rid)")

        for commit in commits {
            print("Commit ID: \(commit.id), Time: \(commit.committer.time)")
        }

        // Sorting and selecting the latest commit
        guard let latestCommit = commits.sorted(by: { $0.committer.time > $1.committer.time }).first else {
            throw NSError(domain: "FileServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No commits found"])
        }

        // Debug print the latest commit SHA
        print("Latest Commit SHA: \(latestCommit.id)")

        return latestCommit.id
    }

}

//
//  FileService.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

protocol FileServiceProtocol {
    func fetchReadme(rid: String) async throws -> ReadmeResponse
    func fetchFileBlob(rid: String, sha: String, path: String) async throws -> RepoFile
}

class FileService: FileServiceProtocol {
    static let shared = FileService()
    private init() {}

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
    
    func fetchFileList(rid: String, sha: String, path: String?) async throws -> [FileEntry] {
        let adjustedPath = path != nil ? "\(path!)" : "" // Ensure proper path formatting
        let endpoint = "repos/\(rid)/tree/\(sha)/\(adjustedPath)"

        print("🌍 API Request: https://seed.radicle.xyz/api/v1/\(endpoint)")

        let response: FileListResponse = try await APIClient.shared.fetch(endpoint: endpoint)
        return response.entries
    }
    
//    func fetchFileBlob(rid: String, sha: String, path: String) async throws -> RepoFile {
//        do {
//            return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/blob/\(sha)/\(path)")
//        } catch let error as NSError {
//            print("Fetch File Blob Error: \(error.localizedDescription)")
//            throw error
//        }
//    }
    
    func fetchFileBlob(rid: String, sha: String, path: String) async throws -> RepoFile {
        do {
            let response: RepoFile = try await APIClient.shared.fetch(endpoint: "repos/\(rid)/blob/\(sha)/\(path)")
            print("📜 File Blob Retrieved: \(response.name), Commit SHA: \(response.lastCommit?.id ?? "Unknown")")
            return response
        } catch let error as NSError {
            print("❌ Fetch File Blob Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchCommitsForFile(rid: String, path: String) async throws -> [CommitResponse] {
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? path
        let endpoint = "repos/\(rid)/commits?path=\(encodedPath)"
        print("🌍 API Request: https://seed.radicle.xyz/api/v1/\(endpoint)")
        
        let response: [CommitResponse] = try await APIClient.shared.fetch(endpoint: endpoint)
        
        print("📡 API Response: \(response.count) commits fetched for \(path)")
        return response
    }
    
    private func fetchLatestCommitSHA(rid: String) async throws -> String {
        let commits = try await CommitService.shared.fetchCommits(rid: rid)

        print("Fetched \(commits.count) commits for repository: \(rid)")

        for commit in commits {
            print("Commit ID: \(commit.id), Time: \(commit.committer.time)")
        }

        guard let latestCommit = commits.sorted(by: { $0.committer.time > $1.committer.time }).first else {
            throw NSError(domain: "FileServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No commits found"])
        }

        print("Latest Commit SHA: \(latestCommit.id)")

        return latestCommit.id
    }
    
    func fetchFileListRecursive(rid: String, sha: String, path: String?) async throws -> [FileEntry] {
            do {
                // If path is not nil, append it to the base tree endpoint
                let baseEndpoint = "repos/\(rid)/tree/\(sha)/"
                let fullEndpoint = path.map { "\(baseEndpoint)\($0)" } ?? baseEndpoint
                print("🌍 API Request: https://seed.radicle.xyz/api/v1/\(fullEndpoint)")

                let response: FileListResponse = try await APIClient.shared.fetch(endpoint: fullEndpoint)
                print("📡 API Response: \(response)")
                return response.entries

            } catch let error as NSError {
                print("❌ API Request Failed: \(error), UserInfo: \(error.userInfo)")
                throw error
            }
    }

}

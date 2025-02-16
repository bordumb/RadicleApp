//
//  NetworkService.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = "https://seed.radicle.garden/api/v1/"
    
    func fetch<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError(error)))
                }
            }
        }
        task.resume()
    }
    
    func fetchRepositories(completion: @escaping (Result<[RepoItem], Error>) -> Void) {
        fetch(endpoint: "repos", completion: completion)
    }
    
    func fetchCommit(rid: String, commit: String, completion: @escaping (Result<CommitResponse, Error>) -> Void) {
        fetch(endpoint: "repos/\(rid)/commits/\(commit)", completion: completion)
    }
    
    func fetchIssues(repoID: String, completion: @escaping (Result<[Issue], Error>) -> Void) {
        fetch(endpoint: "repos/\(repoID)/issues", completion: completion)
    }
    
    func fetchIssue(repoID: String, issueID: String, completion: @escaping (Result<Issue, Error>) -> Void) {
        fetch(endpoint: "repos/\(repoID)/issues/\(issueID)", completion: completion)
    }
    
    func fetchDiff(rid: String, base: String, oid: String, completion: @escaping (Result<DiffResponse, Error>) -> Void) {
        fetch(endpoint: "repos/\(rid)/diff/\(base)/\(oid)", completion: completion)
    }
    
    func fetchRemotes(rid: String, completion: @escaping (Result<[Remote], Error>) -> Void) {
        fetch(endpoint: "repos/\(rid)/remotes", completion: completion)
    }
    
    func fetchReadme(rid: String, sha: String, completion: @escaping (Result<ReadmeResponse, Error>) -> Void) {
        fetch(endpoint: "repos/\(rid)/readme/\(sha)", completion: completion)
    }
    
    func fetchActivity(rid: String, completion: @escaping (Result<[Int], Error>) -> Void) {
        fetch(endpoint: "repos/\(rid)/activity") { (result: Result<ActivityResponse, Error>) in
            switch result {
            case .success(let decodedResponse):
                completion(.success(decodedResponse.activity))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
}

struct RadicleErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

// MARK: - RepoItem
struct RepoItem: Identifiable, Decodable {
    let payloads: Payloads
    let delegates: [DelegateItem]
    let threshold: Int
    let visibility: Visibility
    let rid: String
    let seeding: Int

    var id: String { rid }
}

// MARK: - Repo Activity
struct ActivityResponse: Codable {
    let activity: [Int]
}

// MARK: - Payloads
struct Payloads: Codable {
    let xyzRadicleProject: ProjectPayload?
    
    enum CodingKeys: String, CodingKey {
        case xyzRadicleProject = "xyz.radicle.project"
    }
}

// MARK: - Project Payload
struct ProjectPayload: Codable {
    let data: ProjectData
    let meta: ProjectMeta
}

// MARK: - Project Data
struct ProjectData: Codable {
    let defaultBranch: String
    let description: String
    let name: String
}

// MARK: - Project Metadata
struct ProjectMeta: Codable {
    let head: String
    let issues: IssueStats
    let patches: PatchStats
}

// MARK: - Issue Stats
struct IssueStats: Codable {
    let open: Int
    let closed: Int
}

// MARK: - Patch Stats
struct PatchStats: Codable {
    let open: Int
    let draft: Int
    let archived: Int
    let merged: Int
}

// MARK: - Delegate
struct DelegateItem: Codable, Identifiable {
    let id: String
    let alias: String?
}

// MARK: - Visibility
struct Visibility: Codable {
    let type: String
}

// MARK: - Commit
struct CommitResponse: Codable {
    let commit: CommitInfo
    let diff: CommitDiff
}

struct CommitInfo: Codable {
    let id: String
    let author: Author
    let summary: String
    let description: String
    let parents: [String]
    let committer: Committer
}

struct Author: Codable {
    let name: String
    let email: String
}

struct Committer: Codable {
    let name: String
    let email: String
    let time: Int // Possibly a Unix timestamp
}

struct CommitDiff: Codable {
    let files: [DiffFile]
    let stats: DiffStats
}

struct DiffFile: Codable, Identifiable {
    let status: String // e.g. "modified"
    let path: String
    let diff: FileDiff
    let old: DiffObject
    let new: DiffObject

    var id: String { path } // Using path as a unique identifier
}

struct FileDiff: Codable {
    let type: String // e.g. "plain"
    let hunks: [DiffHunk]
    let stats: HunkStats
    let eof: String
}

struct DiffHunk: Codable {
    let header: String
    let lines: [DiffLine]
    let old: HunkRange
    let new: HunkRange
}

struct DiffLine: Codable {
    let type: String  // "context", "addition", "deletion"
    let line: String
    let lineNoOld: Int?
    let lineNoNew: Int?
}

struct HunkRange: Codable {
    let start: Int
    let end: Int
}

struct HunkStats: Codable {
    let additions: Int
    let deletions: Int
}

struct DiffObject: Codable {
    let oid: String
    let mode: String
}

struct DiffStats: Codable {
    let filesChanged: Int
    let insertions: Int
    let deletions: Int
}

// MARK: - Issue
struct Issue: Codable {
    let id: String
    let title: String
    let state: IssueState
    let author: IssueAuthor
    let assignees: [String]
    let discussion: [IssueDiscussion]
    let labels: [String]
}

struct IssueState: Codable {
    let status: String
}

struct IssueAuthor: Codable {
    let id: String
    let alias: String?
}

struct IssueDiscussion: Codable {
    let id: String
    let author: IssueAuthor
    let body: String
    let edits: [IssueEdit]
    let timestamp: Int
    let replyTo: String?
    let resolved: Bool
}

struct IssueEdit: Codable {
    let author: IssueAuthor
    let body: String
    let timestamp: Int
    let embeds: [String]
}

enum IssueStatus: String, Codable {
    case open, closed
}

struct DiffResponse: Decodable {
    let diff: String
}

struct Remote: Decodable {
    let id: String
    let alias: String?
}

struct ReadmeResponse: Decodable {
    let content: String
}

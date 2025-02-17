//
//  Repository.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

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

struct Remote: Decodable {
    let id: String
    let alias: String?
}

// MARK: - Issue Stats
struct IssueStats: Codable {
    let open: Int
    let closed: Int
}

// MARK: - Delegate
struct DelegateItem: Codable, Identifiable {
    let id: String
    let alias: String?
}

// MARK: - Patch Stats
struct PatchStats: Codable {
    let open: Int
    let draft: Int
    let archived: Int
    let merged: Int
}

// MARK: - Visibility
struct Visibility: Codable {
    let type: String
}

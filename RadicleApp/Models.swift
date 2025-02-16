//
//  Models.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import Foundation

struct RadicleRepository: Identifiable {
    let id: String
    let name: String
    // Add other properties as needed.
}

extension RadicleRepository {
    init(from repoItem: RepoItem) {
        self.id = repoItem.rid
        self.name = repoItem.payloads.xyzRadicleProject.data.name ?? "Untitled"
    }
}

struct RepoItem: Identifiable, Codable {
    let payloads: Payloads
    let delegates: [DelegateItem]
    let threshold: Int
    let visibility: Visibility
    let rid: String
    let seeding: Int
    
    var id: String { rid }
}

struct Payloads: Codable {
    let xyzRadicleProject: XyzRadicleProject
    
    // Map the JSON key "xyz.radicle.project" to our property
    enum CodingKeys: String, CodingKey {
        case xyzRadicleProject = "xyz.radicle.project"
    }
}

struct XyzRadicleProject: Codable {
    let data: ProjectData
    let meta: ProjectMeta
}

struct ProjectData: Codable {
    let defaultBranch: String?
    let description: String?
    let name: String?
}

struct ProjectMeta: Codable {
    let head: String
    let issues: Issues
    let patches: Patches
}

struct Issues: Codable {
    let open: Int
    let closed: Int
}

struct Patches: Codable {
    let open: Int
    let draft: Int
    let archived: Int
    let merged: Int
}

struct DelegateItem: Codable {
    let id: String
    let alias: String
}

struct Visibility: Codable {
    let type: String
}

struct RadicleErrorMessage: Identifiable {
    let message: String
    var id: String { message }
}

extension DiffFile: Identifiable {
    var id: String { path }
}

// Define models to match the JSON payload structure.
struct Issue: Identifiable, Codable {
    let id: String
    let author: User
    let title: String
    let state: IssueState
    let assignees: [User]
    let discussion: [Discussion]
    let labels: [String]?
    let timestamp: TimeInterval?
    // Other fields as needed…
}

extension Issue {
    func withDiscussion(_ discussions: [Discussion]) -> Issue {
        return Issue(
            id: id,
            author: author,
            title: title,
            state: state,
            assignees: assignees,
            discussion: discussions,
            labels: labels,
            timestamp: timestamp
        )
    }
}

struct IssueThread {
    let issue: Issue
    let discussion: [Discussion]
}

struct User: Codable {
    let id: String
    // Even though the payload shows "alias" as "null", you might want to treat it as an optional string.
    let alias: String?
}

struct IssueState: Codable {
    let status: String
}

struct Discussion: Codable {
    let id: String
    let author: User
    let body: String
    let edits: [Edit]?
    let embeds: [Embed]?
    let reactions: [String]? // Adjust type if reactions have a more complex structure.
    let timestamp: TimeInterval
    let replyTo: String?
    let resolved: Bool?
}

struct Edit: Codable {
    let author: User
    let body: String
    let timestamp: TimeInterval
    let embeds: [Embed]?
}

// For now, assuming embeds aren’t used in depth.
struct Embed: Codable { }

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
}

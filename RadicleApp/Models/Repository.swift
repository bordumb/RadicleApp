//
//  Repository.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation // Needed if you want to use UUID or advanced decoding

// MARK: - RepoItem
struct RepoItem: Identifiable, Decodable {
    let payloads: Payloads
    let delegates: [DelegateItem]
    let threshold: Int
    let visibility: Visibility
    let rid: String
    let seeding: Int

    var id: String { rid }
    
    /// Converts Unix timestamp to a `Date`
    var lastUpdatedDate: Date {
        guard let timestamp = payloads.xyzRadicleProject?.meta.lastUpdated else {
            return Date() // Default to now if missing
        }
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
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
    let lastUpdated: Int? // 👈 Change this to Int (Unix timestamp)

    enum CodingKeys: String, CodingKey {
        case head, issues, patches
        case lastUpdated = "updatedAt" // 👈 Ensure this matches your API
    }
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

struct Remote: Decodable, Identifiable {
    let did: String         // Original JSON field "id" is mapped here
    let alias: String?
    let heads: [String: String]
    let delegate: Bool?

    // This key mapping ensures 'did' is decoded from JSON's "id"
    enum CodingKeys: String, CodingKey {
        case did = "id"
        case alias
        case heads
        case delegate
    }

    // For SwiftUI Lists:
    var remoteAlias: String { alias ?? "Anonymous" }
    var isDelegate: Bool { delegate ?? false }

    // MARK: - Identifiable
    var id: String { did }  // SwiftUI uses this as the unique identifier
}


//
//  Commit.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

// MARK: - CommitDetailsResponse
struct CommitDetailsResponse: Codable {
    let commit: CommitResponse
    let diff: CommitDiff?
    let hasMore: Bool?
    let nextPage: String?
}

// MARK: - CommitResponse
struct CommitResponse: Codable {
    let id: String
    let author: Author
    let summary: String
    let description: String?
    let parents: [String]
    let committer: Committer
}

// MARK: - Committer
struct Committer: Codable {
    let name: String
    let email: String
    let time: Int // Unix timestamp
}

// MARK: - Author (Added Codable Conformance)
struct Author: Codable {
    let name: String
    let email: String
}

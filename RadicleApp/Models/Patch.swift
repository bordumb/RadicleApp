//
//  Patch.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

// MARK: - Patch
struct Patch: Identifiable, Codable {
    let id: String
    let author: PatchAuthor
    let title: String
    let state: PatchState
    let target: String
    let labels: [String]
    let merges: [String]
    let assignees: [String]
    let revisions: [PatchRevision]
}

// MARK: - Patch Author
struct PatchAuthor: Codable {
    let id: String
    let alias: String?
}

// MARK: - Patch State
struct PatchState: Codable {
    let status: String // Example: "open"
}

// MARK: - Patch Revision
struct PatchRevision: Codable {
    let id: String
    let author: PatchAuthor
    let description: String
    let edits: [PatchEdit]
    let reactions: [PatchReaction]
    let base: String
    let oid: String
    let refs: [String]
    let discussions: [String]
    let timestamp: Int
    let reviews: [String]
}

// MARK: - Patch Edit
struct PatchEdit: Codable {
    let author: PatchAuthor
    let body: String
    let timestamp: Int
    let embeds: [String]
}

// MARK: - Patch Reaction
struct PatchReaction: Codable {
    let emoji: String
    let authors: [PatchAuthor]
}


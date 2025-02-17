//
//  Commit.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

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

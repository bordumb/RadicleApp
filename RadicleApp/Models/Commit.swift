//
//  Commit.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

// MARK: - CommitDetailsResponse
struct CommitDetailsResponse: Codable {
    let commit: CommitResponse
    let diff: CommitDiff?
}

// MARK: - CommitResponse (Remains the same)
struct CommitResponse: Codable {
    let id: String
    let author: Author
    let summary: String
    let description: String?
    let parents: [String]
    let committer: Committer
}

// MARK: - CommitDiff (Remains the same)
struct CommitDiff: Codable {
    let files: [DiffFile]
    let stats: DiffStats
}

// MARK: - DiffFile
struct DiffFile: Codable, Identifiable {
    let status: String  // "added", "modified"
    let path: String
    let diff: FileDiff?
    let old: DiffObject?
    let new: DiffObject?

    var id: String { path } // Using path as a unique identifier
}

// MARK: - FileDiff
struct FileDiff: Codable {
    let type: String // "plain"
    let hunks: [DiffHunk]
    let eof: String
}

// MARK: - DiffHunk
struct DiffHunk: Codable {
    let header: String
    let lines: [DiffLine]
    let old: HunkRange
    let new: HunkRange
}

// MARK: - DiffLine
struct DiffLine: Codable {
    let type: String  // "context", "addition", "deletion"
    let line: String
    let lineNoOld: Int?
    let lineNoNew: Int?
}

// MARK: - HunkRange
struct HunkRange: Codable {
    let start: Int
    let end: Int
}

// MARK: - DiffStats
struct DiffStats: Codable {
    let filesChanged: Int
    let insertions: Int
    let deletions: Int
}

// MARK: - DiffObject
struct DiffObject: Codable {
    let oid: String
    let mode: String
}

// MARK: - Author & Committer
struct Author: Codable {
    let name: String
    let email: String
}

struct Committer: Codable {
    let name: String
    let email: String
    let time: Int // Unix timestamp
}

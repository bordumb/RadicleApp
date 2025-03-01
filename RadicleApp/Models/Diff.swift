//
//  Diff.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import Foundation

// MARK: - CommitDiff
struct CommitDiff: Codable {
    let files: [DiffFile]
    let stats: DiffStats
}

// MARK: - DiffFile
struct DiffFile: Codable, Identifiable, Equatable {
    let status: String
    let path: String
    let diff: FileDiff?
    let old: DiffObject?
    let new: DiffObject?

    var id: String { path }

    static func == (lhs: DiffFile, rhs: DiffFile) -> Bool {
        return lhs.path == rhs.path
    }
}

// MARK: - FileDiff
struct FileDiff: Codable {
    let type: String
    let hunks: [DiffHunk]?
    let eof: String?
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
    let type: String
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

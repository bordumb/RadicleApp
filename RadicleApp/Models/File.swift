//
//  File.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

struct ReadmeResponse: Codable {
    let binary: Bool
    let name: String
    let content: String
    let path: String
    let lastCommit: CommitDetails
    
    struct CommitDetails: Codable {
        let id: String
        let author: Author
        let summary: String
        let description: String?
        let parents: [String]
        let committer: Committer
        
        struct Author: Codable {
            let name: String
            let email: String
        }
        
        struct Committer: Codable {
            let name: String
            let email: String
            let time: Int
        }
    }
}

struct RepoFile: Codable {
    let name: String
    let path: String
    let content: String?
    let binary: Bool?
    let lastCommit: CommitDetails?  // ✅ Include commit metadata

    struct CommitDetails: Codable {
        let id: String
        let author: Author
        let summary: String
        let description: String?
        let parents: [String]
        let committer: Committer
        
        struct Author: Codable {
            let name: String
            let email: String
        }
        
        struct Committer: Codable {
            let name: String
            let email: String
            let time: Int
        }
    }
}

struct FileEntry: Identifiable, Codable { // ✅ Add Codable (which includes both Decodable & Encodable)
    let id: String // Unique identifier (use `oid` as ID)
    let name: String
    let path: String
    let kind: String // "blob" for files, "tree" for folders
    
    enum CodingKeys: String, CodingKey {
        case id = "oid"  // Use `oid` as the unique identifier
        case name
        case path
        case kind
    }
}

struct FileListResponse: Codable {
    let entries: [FileEntry]
}

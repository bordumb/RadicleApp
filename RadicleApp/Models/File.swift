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
}

struct FileEntry: Codable, Identifiable {
    let id = UUID()
    let path: String
    let oid: String
    let name: String
    let kind: String
    
    enum CodingKeys: String, CodingKey {
        case path, oid, name, kind
    }
}

struct FileListResponse: Codable {
    let entries: [FileEntry]
}

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

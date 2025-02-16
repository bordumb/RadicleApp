//
//  Repository.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import Foundation

struct Repository: Identifiable, Codable {
    // Use the repository ID (rid) as a unique identifier.
    var id: String { rid }
    
    let rid: String
    let name: String
    let description: String?
    let owner: String
    let latestCommit: String
    let updatedAt: String
}


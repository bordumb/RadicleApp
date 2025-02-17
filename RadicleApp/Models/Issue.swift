//
//  Issue.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

// MARK: - Issue
struct Issue: Codable {
    let id: String
    let title: String
    let state: IssueState
    let author: IssueAuthor
    let assignees: [String]
    let discussion: [IssueDiscussion]
    let labels: [String]
}

struct IssueState: Codable {
    let status: String
}

struct IssueAuthor: Codable {
    let id: String
    let alias: String?
}

struct IssueDiscussion: Codable {
    let id: String
    let author: IssueAuthor
    let body: String
    let edits: [IssueEdit]
    let timestamp: Int
    let replyTo: String?
    let resolved: Bool
}

struct IssueEdit: Codable {
    let author: IssueAuthor
    let body: String
    let timestamp: Int
    let embeds: [String]
}

enum IssueStatus: String, Codable {
    case open, closed
}

struct DiffResponse: Decodable {
    let diff: String
}

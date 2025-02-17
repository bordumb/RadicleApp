//
//  IssuesService.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

protocol IssuesServiceProtocol {
    func fetchIssues(rid: String) async throws -> [Issue]
    func fetchIssue(rid: String, issueID: String) async throws -> Issue
    func fetchPatches(rid: String) async throws -> [Patch]
    func fetchPatch(rid: String, patchID: String) async throws -> Patch
}

class IssuesService: IssuesServiceProtocol {
    static let shared = IssuesService()
    private init() {}

    func fetchIssues(rid: String) async throws -> [Issue] {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/issues")
    }

    func fetchIssue(rid: String, issueID: String) async throws -> Issue {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/issues/\(issueID)")
    }

    func fetchPatches(rid: String) async throws -> [Patch] {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/patches")
    }

    func fetchPatch(rid: String, patchID: String) async throws -> Patch {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/patches/\(patchID)")
    }
}

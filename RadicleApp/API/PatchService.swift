//
//  PatchService.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

protocol PatchServiceProtocol {
    func fetchPatches(rid: String) async throws -> [Patch]
    func fetchPatch(rid: String, patchID: String) async throws -> Patch
}

class PatchService: PatchServiceProtocol {
    static let shared = PatchService()
    private init() {}

    func fetchPatches(rid: String) async throws -> [Patch] {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/patches")
    }

    func fetchPatch(rid: String, patchID: String) async throws -> Patch {
        return try await APIClient.shared.fetch(endpoint: "repos/\(rid)/patches/\(patchID)")
    }
}

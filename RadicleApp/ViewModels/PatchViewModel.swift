//
//  PatchViewModel.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import SwiftUI

@MainActor
class PatchViewModel: ObservableObject {
    @Published var patches: [Patch] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadPatches(for repoID: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedPatches = try await PatchService.shared.fetchPatches(rid: repoID)
                self.patches = fetchedPatches
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}

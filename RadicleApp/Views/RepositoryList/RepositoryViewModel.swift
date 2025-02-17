//
//  RepositoryViewModel.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI
import Combine

class RepositoryViewModel: ObservableObject {
    @Published var repositories: [RepoItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    init() {
        fetchRepositories()
    }

    func fetchRepositories() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let repos = try await RepositoryService.shared.fetchRepositories()
                await MainActor.run {
                    self.repositories = repos
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

}

struct ErrorMessage: Identifiable {
    let message: String
    var id: String { message }
}

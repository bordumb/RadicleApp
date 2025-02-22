//
//  RepositoryViewModel.swift
//  RadicleApp
//
//  Created by bordumb on 22/02/2025.
//

import SwiftUI
import Foundation

@MainActor  // Ensures all property updates happen on the main thread
class RepositoryViewModel: ObservableObject {
    @Published var repositories: [RepoItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiClient = APIClient.shared

    init() {
        fetchRepositories()
    }

    func fetchRepositories() {
        Task {
            await loadRepositories()
        }
    }

    private func loadRepositories() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedRepos: [RepoItem] = try await apiClient.fetch(endpoint: "repos")
            repositories = fetchedRepos
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}


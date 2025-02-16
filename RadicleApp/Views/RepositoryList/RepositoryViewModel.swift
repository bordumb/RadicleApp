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
        
        NetworkService.shared.fetchRepositories { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let repos):
                    self.repositories = repos
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct ErrorMessage: Identifiable {
    let message: String
    var id: String { message }
}

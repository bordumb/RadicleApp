//
//  RepositoryViewModel.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import Foundation
import Combine

class RepositoryViewModel: ObservableObject {
    @Published var repositories: [RepoItem] = []
    @Published var isLoading = false
    @Published var errorMessage: RadicleErrorMessage?
    
    func fetchRepositories() {
        isLoading = true
        NetworkService.shared.fetchRepositories { [weak self] (result: Result<[RepoItem], Error>) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let repos):
                self.repositories = repos
            case .failure(let error):
                self.errorMessage = RadicleErrorMessage(message: error.localizedDescription)
            }
        }
    }
}

struct ErrorMessage: Identifiable {
    let message: String
    var id: String { message }
}

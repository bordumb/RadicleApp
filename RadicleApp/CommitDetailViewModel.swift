//
//  CommitDetailViewModel.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import Foundation
import Combine

// Ensure NetworkService.swift is in your project and imported (if needed)

class CommitDetailViewModel: ObservableObject {
    @Published var commitResponse: CommitResponse?
    @Published var isLoading = false
    @Published var errorMessage: RadicleErrorMessage?
    
    func loadCommit(rid: String, commit: String) {
        isLoading = true
        NetworkService.shared.fetchCommit(rid: rid, commit: commit) { [weak self] (result: Result<CommitResponse, Error>) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let commitResp):
                self.commitResponse = commitResp
            case .failure(let error):
                self.errorMessage = RadicleErrorMessage(message: error.localizedDescription)
            }
        }
    }
}

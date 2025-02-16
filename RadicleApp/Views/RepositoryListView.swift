//
//  RepositoryListView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel = RepositoryViewModel() // ViewModel manages data fetching

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading repositories...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.repositories) { repo in
                                RepositoryCardView(repository: repo)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Repositories")
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}


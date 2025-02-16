//
//  RepositoryListView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct RepositoryListView: View {
    @ObservedObject var viewModel = RepositoryViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.repositories) { repo in
                NavigationLink(destination: RepositoryDetailView(repository: repo)) {
                    VStack(alignment: .leading) {
                        // The name is nested in payloads -> xyzRadicleProject -> data
                        Text(repo.payloads.xyzRadicleProject.data.name ?? "Untitled")
                            .font(.headline)
                        
                        if let desc = repo.payloads.xyzRadicleProject.data.description {
                            Text(desc)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Radicle Repos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.fetchRepositories()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                viewModel.fetchRepositories()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
            .alert(item: $viewModel.errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

//
//  RepositoryListView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel = RepositoryViewModel()
    @ObservedObject var apiClient = APIClient.shared  // Observe APIClient changes

    var body: some View {
                
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    NodeInfoView()

                    if viewModel.isLoading {
                        ProgressView("Loading repositories...")
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        repositoryList()
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.fetchRepositories()
            }
            .onChange(of: apiClient.baseURL) {
                print("🔄 Server changed! Reloading repositories...")
                viewModel.fetchRepositories()
            }
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private func repositoryList() -> some View {
        ForEach(viewModel.repositories) { repo in
            RepositoryNavigationLink(repository: repo)
        }
    }
}

// Separate component for NavigationLink
struct RepositoryNavigationLink: View {
    let repository: RepoItem

    var body: some View {
        NavigationLink(destination: RepositoryDetailView(repository: repository)) {
            RepositoryCardView(repository: repository)
                .foregroundColor(.black)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RepositoryListView()
}

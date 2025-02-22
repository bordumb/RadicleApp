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
                            repositoryList()
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            // Black background for the nav bar
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            // Ensure that the nav bar uses a dark color scheme so status bar etc. looks correct
            .toolbarColorScheme(.dark, for: .navigationBar)
            // Insert a custom title with blue text
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Repositories")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onChange(of: apiClient.baseURL) { _ in
                print("🔄 Server changed! Reloading repositories...")
                viewModel.fetchRepositories() // Fetch data when server changes
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
                .foregroundColor(.black) // Ensure it looks interactive
        }
        .buttonStyle(PlainButtonStyle()) // Removes default NavigationLink styling
    }
}

#Preview {
    RepositoryListView()
}

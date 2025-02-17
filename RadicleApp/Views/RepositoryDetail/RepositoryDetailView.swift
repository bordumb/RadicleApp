//
//  RepositoryDetailView.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import SwiftUI
import MarkdownUI

struct RepositoryDetailView: View {
    let repository: RepoItem
    @State private var readmeContent: String = "Loading..."
    
    var body: some View {
        ZStack {
            Color.black // Ensures the background extends to the edges
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                // Repository Name
                Text(repository.payloads.xyzRadicleProject?.data.name ?? "Unknown Repository")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                // Repository ID
                Text(repository.id)
                    .font(.subheadline)
                    .foregroundColor(Color.blue.opacity(0.8))
                
                // Repository Description
                if let description = repository.payloads.xyzRadicleProject?.data.description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.white)
                }
                
                // Tabs for Files and Commits (Placeholder)
                HStack {
                    Button("Files") { }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    Button("Commits") { }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .foregroundColor(.white)
                
                // README Section
                Text("README.md")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top)
                
                ScrollView {
                    Markdown(readmeContent)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
        .task {
            if let response = try? await FileService.shared.fetchReadme(rid: repository.id) {
                DispatchQueue.main.async {
                    readmeContent = response.content
                }
            } else {
                DispatchQueue.main.async {
                    readmeContent = "Failed to load README."
                }
            }
        }
    }
}

//
//  RepositoryDetailView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct RepositoryDetailView: View {
    let repository: RepoItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Show the name
                Text(repository.payloads.xyzRadicleProject?.data.name ?? "No name")
                    .font(.largeTitle)
                
                // Show the description if present
                if let desc = repository.payloads.xyzRadicleProject?.data.description {
                    Text(desc)
                }
                
                // Show the radicle ID
                Text("RID: \(repository.rid)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                // Delegates
                if !repository.delegates.isEmpty {
                    Text("Delegates:")
                        .font(.headline)
                    ForEach(repository.delegates, id: \.id) { delegate in
                        Text("• \(delegate.alias ?? "Unknown Alias") (\(delegate.id))")
                            .font(.subheadline)
                    }
                }
                
                // Seeding
                Text("Seeding: \(repository.seeding)")
                    .font(.footnote)
                
                // Meta info
                let meta = repository.payloads.xyzRadicleProject?.meta
                Text("HEAD: \(meta?.head ?? "No HEAD available")")
                Text("Issues open: \(meta?.issues.open ?? 0), closed: \(meta?.issues.closed ?? 0)")
                Text("Patches open: \(meta?.patches.open ?? 0), merged: \(meta?.patches.merged ?? 0)")
                
                // Add some spacing before the new links
                Spacer().frame(height: 20)
                
                // 1) View HEAD Commit
                NavigationLink(destination: CommitDetailView(rid: repository.rid,
                                                             commitHash: meta?.head ?? "No Commit")) {
                    Text("View HEAD Commit")
                        .font(.headline)
                        .padding()
                }
                
                // 2) View Source Code (if you have a RepositorySourceView)
                //    (comment out or remove if you haven't implemented it yet)
                NavigationLink(destination: RepositorySourceView(rid: repository.rid,
                                                                 commit: meta?.head ?? "No Commit")) {
                    Text("View Source Code")
                        .font(.headline)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(repository.payloads.xyzRadicleProject?.data.name ?? "Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

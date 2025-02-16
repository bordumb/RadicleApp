//
//  RepositoryCardView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct RepositoryCardView: View {
    let repository: RepoItem

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(UIColor.darkGray)) // Use a dark gray background
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    // Top row: Repo name + seeders count
                    HStack {
                        Text(repository.payloads.xyzRadicleProject?.data.name ?? "Unknown Repo")
                            .font(.headline)
                            .foregroundColor(.white)  // White text for contrast
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Number of seeders in the top right
                        Text("\(repository.seeding) seeders")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }

                    // Description below the name
                    Text(repository.payloads.xyzRadicleProject?.data.description ?? "No description available")
                        .font(.subheadline)
                        .foregroundColor(.gray) // Light gray text for readability
                        .lineLimit(2)

                    // Latest commit at the bottom
                    Text("Latest commit: \(repository.payloads.xyzRadicleProject?.meta.head ?? "No recent commits")")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    Spacer()
                }
                .padding()
            )
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2) // Adds depth
    }
}


#Preview {
    RepositoryCardView(repository: RepoItem(
        payloads: Payloads(
            xyzRadicleProject: ProjectPayload(
                data: ProjectData(
                    defaultBranch: "main",
                    description: "Example Radicle repository",
                    name: "radicle-sample-repo"
                ),
                meta: ProjectMeta(
                    head: "abcdef1234567890",
                    issues: IssueStats(open: 5, closed: 10),
                    patches: PatchStats(open: 3, draft: 1, archived: 2, merged: 7)
                )
            )
        ),
        delegates: [
            DelegateItem(id: "did:key:xyz", alias: "sample-delegate")
        ],
        threshold: 1,
        visibility: Visibility(type: "public"),
        rid: "rad:xyz123",
        seeding: 42
    ))
}

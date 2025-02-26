//
//  CommitDiffLink.swift
//  RadicleApp
//
//  Created by bordumb on 25/02/2025.
//

import SwiftUI

struct CommitDiffLink: View {
    let rid: String
    let commit: CommitResponse

    var body: some View {
        NavigationLink(destination: CommitDiffView(rid: rid, commitId: commit.id)) {
            Text("\(commit.id.prefix(7))")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.blue)
                .padding(8)
                .background(Color.gray.opacity(0.2)) // Gray box background
                .cornerRadius(6) // Rounded edges
        }
        .padding(.top, 5)
    }
}

#Preview {
    CommitDiffLink(
        rid: "",
        commit: CommitResponse(
            id: "abcdefg1234567",
            author: Author(name: "John Doe", email: "john@example.com"),
            summary: "Initial commit",
            description: "",
            parents: [],
            committer: Committer(name: "John Doe", email: "john@example.com", time: 1234)
        )
    )
}

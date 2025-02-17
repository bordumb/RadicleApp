//
//  PatchDetailView.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import SwiftUI

struct PatchDetailView: View {
    let patch: Patch

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(patch.title)
                .font(.title)
                .bold()

            Text("Status: \(patch.state.status)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Divider()

            Text("Revisions")
                .font(.headline)

            ForEach(patch.revisions, id: \.id) { revision in
                VStack(alignment: .leading) {
                    Text("Revision by \(revision.author.alias ?? "Unknown")")
                        .font(.subheadline)
                        .bold()
                    Text(revision.description)
                        .font(.body)
                }
                .padding(.vertical, 5)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Patch Details")
    }
}

#Preview {
    let sampleRevision = PatchRevision(
        id: "rev123",
        author: PatchAuthor(id: "did:key:author1", alias: "devUser1"),
        description: "Fixed issue with login validation.",
        edits: [
            PatchEdit(
                author: PatchAuthor(id: "did:key:author1", alias: "devUser1"),
                body: "Added validation for email format.",
                timestamp: 1739441858,
                embeds: []
            )
        ],
        reactions: [
            PatchReaction(emoji: "🚀", authors: [
                PatchAuthor(id: "did:key:user2", alias: "tester")
            ])
        ],
        base: "base123",
        oid: "oid123",
        refs: ["refs/heads/patches/rev123"],
        discussions: [],
        timestamp: 1739441858,
        reviews: []
    )

    let samplePatch = Patch(
        id: "12345",
        author: PatchAuthor(id: "did:key:author1", alias: "devUser1"),
        title: "Fix login issue",
        state: PatchState(status: "open"),
        target: "delegates",
        labels: ["bugfix", "UI"],
        merges: [],
        assignees: [],
        revisions: [sampleRevision]
    )

    return PatchDetailView(patch: samplePatch)
}

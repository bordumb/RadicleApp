//
//  RemoteCommitDetails.swift
//  RadicleApp
//
//  Created by bordumb on 26/02/2025.
//

import SwiftUI

struct RemoteCommitDetails: View {
    @Binding var selectedBranch: String
    var commitHistory: [CommitResponse] // List of commits
    var selectedCommit: CommitResponse? {
        commitHistory.first(where: { String($0.id.prefix(7)) == selectedBranch }) ?? commitHistory.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 🔹 Branch Selector Button
            // 🔹 Display Selected Commit Info
            if let commit = selectedCommit {
                HStack {
                    Text(commit.id.prefix(7))
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(Color.gray)
                    Text(commit.summary)
                        .font(.body)
                        .foregroundColor(Color.foregroundContrast)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(8)
                .frame(minWidth: 200, minHeight: 40)
                .background(Color.fillGhost)
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }
}

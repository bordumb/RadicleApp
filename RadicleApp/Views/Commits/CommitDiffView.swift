//
//  CommitDiffView.swift
//  RadicleApp
//
//  Created by bordumb on 25/02/2025.
//

import SwiftUI

struct CommitDiffView: View {
    let rid: String
    let commitId: String

    @State private var commitDetails: CommitDetailsResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isLoading {
                ProgressView("Loading commit details...")
            } else if let commit = commitDetails {
                // 📝 Commit Metadata
                VStack(alignment: .leading, spacing: 6) {
                    Text(commit.commit.summary)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)

                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)

                        Text(commit.commit.author.name)
                            .bold()
                            .foregroundColor(.white)

                        Text("committed")
                            .foregroundColor(.gray)

                        Text(commit.commit.id.prefix(7))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)
                    }

                    Text(formattedDate(commit.commit.committer.time))
                        .font(.caption)
                        .foregroundColor(.gray)

                    if let description = commit.commit.description, !description.isEmpty {
                        Text(description)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.vertical, 4)
                }
                .padding(.bottom, 10)

                // 📜 Diff View
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(commitDetails?.diff?.files ?? [], id: \.path) { file in
                            FileDiffView(file: file)
                        }
                    }
                    .padding()
                }
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)

            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchCommitDetails()
        }
    }

    private func fetchCommitDetails() {
        Task {
            do {
                print("Fetching commit details for \(commitId)")
                let details = try await CommitService.shared.fetchCommitDetails(rid: rid, commit: commitId)
                
                DispatchQueue.main.async {
                    self.commitDetails = details
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch commit details: \(error.localizedDescription)"
                    self.isLoading = false
                }
                print("Fetch Commit Details Error: \(error)")
            }
        }
    }

    private func formattedDate(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy HH:mm"
        return formatter.string(from: date)
    }
}

//
//  CommitDiffView.swift
//  RadicleApp
//
//  Created by bordumb on 25/02/2025.
//

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
    @State private var isLoadingMore = false // Track additional loading

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isLoading {
                ProgressView("Loading commit details...")
            } else if let commit = commitDetails {
                commitMetadataView(commit) // Extracted Commit Metadata

                diffListView(commit) // Extracted Diff List (fixed type-checking issue)

            } else if let errorMessage = errorMessage {
                errorView(errorMessage) // Extracted Error Handling
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchCommitDetails()
        }
    }

    // Extracted: Commit Metadata View
    private func commitMetadataView(_ commit: CommitDetailsResponse) -> some View {
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
        }
        .padding(.bottom, 10)
    }

    // Extracted: Diff List View (Fixed Type-Checking Issue)
    private func diffListView(_ commit: CommitDetailsResponse) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                fileListView(commit.diff?.files ?? []) // ✅ Moved `ForEach` to another function
                
                if isLoadingMore {
                    ProgressView("Loading more files...").padding()
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }

    // Extracted: File List ForEach (Fixes Type-Checking Issue)
    private func fileListView(_ files: [DiffFile]) -> some View {
        ForEach(files, id: \.path) { file in
            FileDiffView(file: file)
                .onAppear {
                    if file == files.last {
                        loadMoreFiles()
                    }
                }
        }
    }

    // Extracted: Error View
    private func errorView(_ message: String) -> some View {
        Text("Error: \(message)")
            .foregroundColor(.red)
    }

    /// Fetch commit details asynchronously
    private func fetchCommitDetails() {
        Task {
            do {
                let details = try await CommitService.shared.fetchCommitDetails(rid: rid, commit: commitId)

                await MainActor.run {
                    self.commitDetails = details
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch commit details: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

    /// Loads more files when scrolling to the bottom, optimized for large commits
    private func loadMoreFiles() {
        guard let commitDetails = commitDetails, let nextPage = commitDetails.nextPage, !isLoadingMore else { return }
        isLoadingMore = true

        Task {
            do {
                let moreDetails = try await CommitService.shared.fetchCommitDetails(rid: rid, commit: commitId, nextPage: nextPage)

                await MainActor.run {
                    // Step 1: Safely extract existing files (avoid deep optionals)
                    var updatedFiles: [DiffFile] = commitDetails.diff?.files ?? []

                    // Step 2: Append new files from API
                    if let moreFiles = moreDetails.diff?.files {
                        updatedFiles.append(contentsOf: moreFiles)
                    }

                    // Step 3: Create a new `CommitDiff` object separately
                    let updatedDiff = CommitDiff(
                        files: updatedFiles,
                        stats: commitDetails.diff?.stats ?? DiffStats(filesChanged: 0, insertions: 0, deletions: 0)
                    )

                    // Step 4: Create a new `CommitDetailsResponse` object separately
                    let updatedCommitDetails = CommitDetailsResponse(
                        commit: commitDetails.commit,
                        diff: updatedDiff,
                        hasMore: moreDetails.hasMore,
                        nextPage: moreDetails.nextPage
                    )

                    // Step 5: Assign the newly created struct
                    self.commitDetails = updatedCommitDetails

                    isLoadingMore = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load more files: \(error.localizedDescription)"
                    self.isLoadingMore = false
                }
            }
        }
    }

    /// Formats a Unix timestamp into a readable date
    private func formattedDate(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy HH:mm"
        return formatter.string(from: date)
    }
}

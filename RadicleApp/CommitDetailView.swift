//
//  CommitDetailView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct CommitDetailView: View {
    let rid: String
    let commitHash: String
    
    @ObservedObject var viewModel = CommitDetailViewModel()
    
    var body: some View {
        ScrollView {
            if let commitResp = viewModel.commitResponse {
                CommitDetailsView(commitResp: commitResp)
            } else {
                Text("No commit data.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .navigationTitle("Commit \(commitHash)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadCommit(rid: rid, commit: commitHash)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading commit info...")
            }
        }
        .alert(item: $viewModel.errorMessage) { err in
            Alert(title: Text("Error"), message: Text(err.message), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - Commit Details Subview

struct CommitDetailsView: View {
    let commitResp: CommitResponse
    
    var body: some View {
        // Extracting sub-expressions for clarity
        let commit = commitResp.commit
        let diffStats = commitResp.diff.stats
        let parentsString = commit.parents.joined(separator: ", ")
        let committerTime = Date(timeIntervalSince1970: TimeInterval(commit.committer.time))
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Commit: \(commit.id)")
                .font(.headline)
            
            Text("Author: \(commit.author.name) <\(commit.author.email)>")
            
            Text("Summary: \(commit.summary)")
            
            Text("Description: \(commit.description)")
            
            Text("Commits Parents: \(parentsString)")
            
            Text("Committed by: \(commit.committer.name) on \(committerTime)")
            
            Text("Files Changed: \(diffStats.filesChanged)")
            Text("Insertions: \(diffStats.insertions)")
            Text("Deletions: \(diffStats.deletions)")
            
            // Display diff details for each file
            ForEach(commitResp.diff.files) { file in
                FileDiffView(file: file)
            }
        }
        .padding()
    }
}

// MARK: - File Diff Subview

struct FileDiffView: View {
    let file: DiffFile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(file.status.uppercased()): \(file.path)")
                .bold()
            
            // Iterate over hunks in the diff
            ForEach(file.diff.hunks.indices, id: \.self) { i in
                let hunk = file.diff.hunks[i]
                Text("Hunk \(i + 1) lines: \(hunk.lines.count)")
                    .font(.subheadline)
            }
        }
        .padding(.top, 8)
    }
}

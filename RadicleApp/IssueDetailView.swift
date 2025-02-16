//
//  IssueDetailView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUICore
import SwiftUI

struct IssueDetailView: View {
    let repoID: String
    let issueID: String
    
    @State private var issue: Issue?
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if let issue = issue {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(issue.title)
                            .font(.headline)
                        
                        Text("Status: \(issue.state.status.capitalized)")
                            .foregroundColor(.secondary)
                        
                        Text("Author: \(issue.author.alias ?? issue.author.id)")
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        Text(issue.discussion.first?.body ?? "No discussion available.")
                            .padding(.top)
                    }
                    .padding()
                }
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ProgressView("Loading Issue...")
                    .padding()
            }
        }
        .navigationTitle("Issue Details")
        .onAppear {
            NetworkService.shared.fetchIssue(repoID: repoID, issueID: issueID) { result in
                switch result {
                case .success(let fetchedIssue):
                    self.issue = fetchedIssue
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

//
//  RepositoryDetailView.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import SwiftUI
import MarkdownUI
import UIKit

struct RepositoryDetailView: View {
    let repository: RepoItem

    @State private var readmeContent: String = "Loading..."
    @State private var selectedBranch: String = "main"
    @State private var commitHistory: [CommitResponse] = []
    @State private var selectedTab: TabSelection = .files
    @EnvironmentObject var apiClient: APIClient
    
    var repositoryURL: String {
        "https://app.radicle.xyz/nodes/seed.radicle.xyz/\(repository.id)"
    }

    enum TabSelection {
        case files, commits
    }

    var latestCommitSHA: String? {
        commitHistory.first?.id
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(repository.payloads.xyzRadicleProject?.data.name ?? "Unknown Repository")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    
                    LinkButton(URL: repositoryURL)
                    
                    HStack(spacing: 4) {
                        Icon(name: .radicleSeed, size: 16)
                        Text("\(repository.seeding)")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white)
                    }
                }

                BranchSelectorDropdown(selectedBranch: $selectedBranch, commitHistory: commitHistory, canonicalBranch: "main")
                
                HStack {
                    Button(action: { selectedTab = .files }) {
                        HStack {
                            Icon(name: .file, size: 16, color: selectedTab == .files ? .black : .white) // Explicit color application
                            Text("Files")
                        }
                        .padding()
                        .background(selectedTab == .files ? Color.white : Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .foregroundColor(selectedTab == .files ? .black : .white) // Ensure text and icon color updates

                    Button(action: { selectedTab = .commits }) {
                        HStack {
                            Icon(name: .commit, size: 16, color: selectedTab == .commits ? .black : .white) // Explicit color application
                            Text("Commits")
                        }
                        .padding()
                        .background(selectedTab == .commits ? Color.white : Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .foregroundColor(selectedTab == .commits ? .black : .white) // Ensure text and icon color updates


                }
                .padding(.vertical, 6)
                if selectedTab == .files {
                    VStack(alignment: .leading, spacing: 10) {
                        // Browse Files Button
                        if let latestCommitSHA = latestCommitSHA {
                            NavigationLink(destination: FileListView(rid: repository.id, sha: latestCommitSHA, path: nil)) {
                                Text("Browse")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                        }
                        Text("README.md")
                            .font(.headline)
                            .foregroundColor(.white)
                        ScrollView {
                            Markdown(readmeContent)
                                .markdownTheme(.gitHub)
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        ForEach(groupCommitsByDate(), id: \.key) { date, commits in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(date)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                                ForEach(commits, id: \.id) { commit in
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(commit.summary)
                                            .font(.body)
                                            .foregroundColor(.white)
                                        Text("\(commit.author.name) committed \(commit.id.prefix(7))")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("\(timeAgo(from: commit.committer.time))")
                                            .font(.caption2)
                                            .foregroundColor(.gray.opacity(0.7))
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding()
        }
        .task {
            await fetchReadme()
            await fetchCommits()
        }
    }
    // 📥 Fetch README Content
    func fetchReadme() async {
        do {
            let response = try await FileService.shared.fetchReadme(rid: repository.id)
            readmeContent = response.content
        } catch {
            readmeContent = "Failed to load README."
        }
    }

    // 📥 Fetch Commit History
    func fetchCommits() async {
        do {
            commitHistory = try await CommitService.shared.fetchCommits(rid: repository.id)
        } catch {
            commitHistory = []
        }
    }

    // 📆 Helper: Group Commits by Date
    func groupCommitsByDate() -> [(key: String, value: [CommitResponse])] {
        let grouped = Dictionary(grouping: commitHistory) { commit in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            let date = Date(timeIntervalSince1970: TimeInterval(commit.committer.time))
            return dateFormatter.string(from: date)
        }
        return grouped.sorted { $0.key > $1.key }
    }

    // ⏳ Helper: Convert Unix Timestamp to "n days ago"
    func timeAgo(from timestamp: Int) -> String {
        let commitDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let now = Date()
        let diff = Calendar.current.dateComponents([.day], from: commitDate, to: now)
        if let days = diff.day {
            return "\(days) days ago"
        } else {
            return "Recently"
        }
    }
}

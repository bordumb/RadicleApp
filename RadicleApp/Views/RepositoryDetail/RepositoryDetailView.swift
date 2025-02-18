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
    @State private var selectedBranch: String = "master"
    @State private var commitHistory: [CommitResponse] = []
    @State private var selectedTab: TabSelection = .files // Track active tab
    
    var repositoryURL: String {
        "https://app.radicle.xyz/nodes/seed.radicle.xyz/\(repository.id)"
    }

    enum TabSelection {
        case files, commits
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                // 🏷️ Repository Name & URL Copy Button
                HStack {
                    Text(repository.payloads.xyzRadicleProject?.data.name ?? "Unknown Repository")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()

                    Button(action: {
                        UIPasteboard.general.string = repositoryURL
                    }) {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }

                // 🌱 Seeder Count
                Text("🌱 Seeders: \(repository.seeding)")
                    .foregroundColor(.white.opacity(0.7))

                // 🔻 Branch Selection
                HStack {
                    Text("Branch:")
                        .foregroundColor(.white)

                    Menu {
                        Button("master") { selectedBranch = "master" }
                        ForEach(commitHistory.map { $0.id.prefix(7) }, id: \.self) { commitID in
                            Button(commitID) { selectedBranch = String(commitID) }
                        }
                    } label: {
                        Text(selectedBranch)
                            .padding(6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                            .foregroundColor(.white)
                    }
                }

                // 📝 Latest Commit Information
                let selectedCommit = selectedBranch == "master"
                    ? commitHistory.first
                    : commitHistory.first(where: { $0.id.hasPrefix(selectedBranch) })

                if let commit = selectedCommit {
                    Text("Latest Commit: \(commit.id.prefix(7)) - \(commit.summary)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                // 🗂️ Tabs for Files & Commits
                HStack {
                    // 📂 Files Tab
                    Button(action: { selectedTab = .files }) {
                        Text("Files")
                            .foregroundColor(selectedTab == .files ? .black : .white)
                            .padding()
                            .background(selectedTab == .files ? Color.white : Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    // 📜 Commits Tab
                    Button(action: { selectedTab = .commits }) {
                        Text("Commits")
                            .foregroundColor(selectedTab == .commits ? .black : .white)
                            .padding()
                            .background(selectedTab == .commits ? Color.white : Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.vertical, 6)

                // 🔹 Toggle between Tabs
                if selectedTab == .files {
                    // 📂 FILES TAB CONTENT
                    VStack(alignment: .leading, spacing: 10) {
                        Button(action: {}) {
                            Text("Browse")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }

                        // 📖 README Section
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
                    // 📜 COMMITS TAB CONTENT
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
//
//
//struct RepositoryDetailView: View {
//    let repository: RepoItem
//    
//    @State private var readmeContent: String = "Loading..."
//    @State private var selectedBranch: String = "master"
//    @State private var commitHistory: [CommitResponse] = []
//    @State private var showCopiedMessage = false
//    
//    var repositoryURL: String {
//        "https://app.radicle.xyz/nodes/seed.radicle.xyz/\(repository.id)"
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            
//            VStack(alignment: .leading, spacing: 12) {
//                // 🏷️ Repository Name
//                Text(repository.payloads.xyzRadicleProject?.data.name ?? "Unknown Repository")
//                    .font(.title)
//                    .bold()
//                    .foregroundColor(.white)
//                
//                HStack {
//                    // 🌐 URL Copy Button
//                    Button(action: {
//                        UIPasteboard.general.string = repositoryURL
//                        showCopiedMessage = true
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                            showCopiedMessage = false
//                        }
//                    }) {
//                        Image(systemName: "link")
//                            .foregroundColor(.blue)
//                            .padding(8)
//                            .background(Color.white.opacity(0.1))
//                            .clipShape(Circle())
//                    }
//                    .buttonStyle(PlainButtonStyle()) // Removes default button styling
//                    
//                    if showCopiedMessage {
//                        Text("Copied!")
//                            .font(.caption)
//                            .foregroundColor(.green)
//                            .transition(.opacity)
//                    }
//
//                    Spacer()
//                    
//                    // 🌱 Seeder Count
//                    Text("🌱 Seeders: \(repository.seeding)")
//                        .foregroundColor(.white.opacity(0.7))
//                }
//
//                // 📜 Repository Description
//                if let description = repository.payloads.xyzRadicleProject?.data.description {
//                    Text(description)
//                        .font(.body)
//                        .foregroundColor(.white)
//                }
//
//                // 🔻 Branch Selection Dropdown
//                HStack {
//                    Text("Branch:")
//                        .foregroundColor(.white)
//
//                    Menu {
//                        Button("master") { selectedBranch = "master" }
//                        ForEach(commitHistory.map { $0.id.prefix(7) }, id: \.self) { commitID in
//                            Button(commitID) { selectedBranch = String(commitID) }
//                        }
//                    } label: {
//                        Text(selectedBranch)
//                            .padding(6)
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(6)
//                            .foregroundColor(.white)
//                    }
//                }
//
//                // 📝 Latest Commit Information (Handles 'master' case)
//                let selectedCommit = selectedBranch == "master"
//                    ? commitHistory.first // Default to the latest commit
//                    : commitHistory.first(where: { $0.id.hasPrefix(selectedBranch) })
//
//                if let commit = selectedCommit {
//                    Text("Latest Commit: \(commit.id.prefix(7)) - \(commit.summary)")
//                        .font(.caption)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//
//                // 📖 README Section
//                Text("README.md")
//                    .font(.headline)
//                    .foregroundColor(.white)
//
//                ScrollView {
//                    Markdown(readmeContent)
//                        .markdownTheme(.gitHub)
//                        .foregroundStyle(.white)
//                        .padding()
//                }
//                .background(Color.black.opacity(0.1))
//                .cornerRadius(10)
//
//                Spacer()
//            }
//            .padding()
//        }
//        .task {
//            await fetchReadme()
//            await fetchCommits()
//        }
//    }
//
//    // 📥 Fetch README Content
//    func fetchReadme() async {
//        do {
//            let response = try await FileService.shared.fetchReadme(rid: repository.id)
//            readmeContent = response.content
//        } catch {
//            readmeContent = "Failed to load README."
//        }
//    }
//
//    // 📥 Fetch Commit History
//    func fetchCommits() async {
//        do {
//            commitHistory = try await CommitService.shared.fetchCommits(rid: repository.id)
//        } catch {
//            commitHistory = []
//        }
//    }
//}

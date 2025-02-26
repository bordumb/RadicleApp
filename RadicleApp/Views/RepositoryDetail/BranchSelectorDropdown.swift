//
//  BranchSelectorDropdown.swift
//  RadicleApp
//
//  Created by bordumb on 26/02/2025.
//

import SwiftUI

struct BranchSelectorDropdown: View {
    @Binding var selectedBranch: String
    var commitHistory: [CommitResponse] // List of commits
    var canonicalBranch: String // The actual branch name (e.g., "main")

    @State private var expandedAuthors: [String: Bool] = [:] // Track expanded authors
    @State private var isDropdownVisible: Bool = false // Track dropdown visibility

    var displayBranch: String {
        selectedBranch == canonicalBranch ? "master" : selectedBranch
    }

    var selectedCommit: CommitResponse? {
        if selectedBranch == canonicalBranch {
            return commitHistory.first // Get latest commit
        }
        return commitHistory.first(where: { String($0.id.prefix(7)) == selectedBranch })
    }

    var groupedCommits: [String: [CommitResponse]] {
        Dictionary(grouping: commitHistory, by: { $0.author.name })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 🔹 Branch Selector Button
            Button(action: {
                withAnimation {
                    isDropdownVisible.toggle()
                }
            }) {
                HStack {
                    Icon(name: .branch, size: 16, color: Color.foregroundContrast)
                    Text(displayBranch)
                        .foregroundColor(Color.foregroundContrast)
                        .font(.body)
                    
                    Spacer()
                    
                    Icon(name: isDropdownVisible ? .chevronDown : .chevronRight, size: 16, color: .white)
                }
                .padding(8)
                .frame(minWidth: 160, minHeight: 40)
                .background(Color.fillGhost)
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }

            // 🔽 Expandable Dropdown List
            if isDropdownVisible {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(groupedCommits.keys.sorted(), id: \.self) { author in
                            VStack(alignment: .leading, spacing: 4) {
                                Button(action: {
                                    withAnimation {
                                        expandedAuthors[author] = !(expandedAuthors[author] ?? false)
                                    }
                                }) {
                                    HStack {
                                        Icon(name: expandedAuthors[author] == true ? .chevronDown : .chevronRight, size: 16, color: .white)
                                        Text(author)
                                            .foregroundColor(.white)
                                            .bold()
                                        Spacer()
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 8)
                                    .background(Color.black.opacity(0.2))
                                }

                                // 🔹 Show commits when expanded
                                if expandedAuthors[author] == true {
                                    ForEach(groupedCommits[author] ?? [], id: \.id) { commit in
                                        Button(action: {
                                            selectedBranch = String(commit.id.prefix(7))
                                            isDropdownVisible = false // Close after selection
                                        }) {
                                            HStack {
                                                Icon(name: .branch, size: 14, color: .gray)
                                                Text(commit.id.prefix(7))
                                                    .foregroundColor(.gray)
                                                Text(commit.summary)
                                                    .foregroundColor(.white.opacity(0.8))
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                            }
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 12)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: 300) // Limit height to make it scrollable
                .background(Color.fillGhost)
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }

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


//
//#Preview {
//    BranchSelectionButton(
//        selectedBranch: .constant("main"), // Default to canonical branch
//        commitHistory: [
//            CommitResponse(id: "abcdef1234567890",
//                           author: Author(name: "Alice", email: "alice@example.com"),
//                           summary: "Initial commit",
//                           description: "Setup project structure",
//                           parents: [],
//                           committer: Committer(name: "Alice", email: "alice@example.com", time: 1700000000)),
//            CommitResponse(id: "1234567890abcdef",
//                           author: Author(name: "Bob", email: "bob@example.com"),
//                           summary: "Fix bug",
//                           description: "Fixed a major issue",
//                           parents: [],
//                           committer: Committer(name: "Bob", email: "bob@example.com", time: 1700005000)),
//            CommitResponse(id: "fedcba0987654321",
//                           author: Author(name: "Alice", email: "alice@example.com"),
//                           summary: "Refactor code",
//                           description: "Updated structure",
//                           parents: [],
//                           committer: Committer(name: "Alice", email: "alice@example.com", time: 1700001000))
//        ],
//        canonicalBranch: "main"
//    )
//}
//
//
//import SwiftUI
//
//struct BranchSelectionButton: View {
//    @Binding var selectedBranch: String
//    var commitHistory: [CommitResponse] // List of commits
//    var canonicalBranch: String // The actual branch name (e.g., "main")
//
//    var displayBranch: String {
//        selectedBranch == canonicalBranch ? "master" : selectedBranch
//    }
//
//    var selectedCommit: CommitResponse? {
//        if selectedBranch == canonicalBranch {
//            return commitHistory.first // Get latest commit
//        }
//        return commitHistory.first(where: { String($0.id.prefix(7)) == selectedBranch })
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            // 🔹 Branch Selector
//            Menu {
//                Button("master") { selectedBranch = canonicalBranch }
//                ForEach(commitHistory.map { String($0.id.prefix(7)) }, id: \.self) { commitID in
//                    Button(commitID) { selectedBranch = commitID }
//                }
//            } label: {
//                HStack {
//                    Icon(name: .branch, size: 16, color: Color.foregroundContrast)
//                    
//                    Text(displayBranch)
//                        .foregroundColor(Color.foregroundContrast) // Ensure text is visible
//                        .font(.body)
//                    
//                    Icon(name: .chevronDown, size: 16, color: Color.foregroundContrast)
//                }
//                .padding(8)
//                .frame(minWidth: 120, minHeight: 40) // Ensure proper layout
//                .background(Color.fillGhost)
//                .overlay(
//                    Rectangle()
//                        .stroke(Color.gray.opacity(0.0), lineWidth: 1) // Sharp-edged border
//                )
//            }
//
//            // 🔹 Dynamically Update Commit Info
//            if let commit = selectedCommit {
//                HStack {
//                    Text("\(commit.id.prefix(7))")
//                        .font(.system(size: 14, weight: .medium, design: .monospaced))
//                        .foregroundColor(Color.gray)
//                    Text("\(commit.summary)")
//                        .font(.body)
//                        .foregroundColor(Color.foregroundContrast)
//                        .lineLimit(1) // Ensure text doesn't overflow
//                        .truncationMode(.tail)
//                }
//                .padding(8)
//                .frame(minWidth: 200, minHeight: 40) // Consistent size with selector
//                .background(Color.fillGhost)
//                .overlay(
//                    Rectangle()
//                        .stroke(Color.gray.opacity(0.0), lineWidth: 1) // Sharp-edged border
//                )
//            }
//        }
//    }
//}
//
//#Preview {
//    BranchSelectionButton(
//        selectedBranch: .constant("main"), // Default to canonical branch
//        commitHistory: [
//            CommitResponse(id: "abcdef1234567890",
//                           author: Author(name: "Alice", email: "alice@example.com"),
//                           summary: "Initial commit",
//                           description: "Setup project structure",
//                           parents: [],
//                           committer: Committer(name: "Alice", email: "alice@example.com", time: 1700000000)),
//            CommitResponse(id: "1234567890abcdef",
//                           author: Author(name: "Bob", email: "bob@example.com"),
//                           summary: "Fix bug",
//                           description: "Fixed a major issue",
//                           parents: [],
//                           committer: Committer(name: "Bob", email: "bob@example.com", time: 1700005000))
//        ],
//        canonicalBranch: "main" // Set the canonical branch
//    )
//}

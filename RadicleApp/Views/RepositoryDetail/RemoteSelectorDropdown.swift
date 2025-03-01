//
//  RemoteSelectorDropdown.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import SwiftUI

struct RemoteSelectorDropdown: View {
    @Binding var selectedBranch: String          // The branch/patch name that user selects
    var remotes: [Remote]                        // The array of Remote objects from /remotes
    
    @State private var expandedRemotes: [String: Bool] = [:] // Track which remote is expanded
    @State private var isDropdownVisible: Bool = false       // Track dropdown overall visibility

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 🔹 Dropdown Toggle Button
            Button(action: {
                withAnimation {
                    isDropdownVisible.toggle()
                }
            }) {
                HStack {
                    Text(selectedBranch.isEmpty ? "Select a Branch" : selectedBranch)
                        .foregroundColor(.white)
                        .font(.body)

                    Spacer()

                    // Chevron for overall dropdown
                    Image(systemName: isDropdownVisible ? "chevron.down" : "chevron.right")
                        .foregroundColor(.white)
                }
                .padding(8)
                .frame(minWidth: 200, minHeight: 40)
                .background(Color.fillGhost)
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }

            // 🔽 The dropdown contents
            if isDropdownVisible {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        // Loop over each remote (author)
                        ForEach(remotes) { remote in
                            // If no alias, fallback to "Anonymous"
                            let alias = remote.alias ?? "Anonymous"
                            
                            VStack(alignment: .leading, spacing: 4) {
                                // 🔹 Remote "header"
                                Button(action: {
                                    withAnimation {
                                        expandedRemotes[remote.id] = !(expandedRemotes[remote.id] ?? false)
                                    }
                                }) {
                                    HStack {
                                        // Show down vs right chevron
                                        Image(systemName: expandedRemotes[remote.id] == true ? "chevron.down" : "chevron.right")
                                            .foregroundColor(.white)
                                        
                                        Text(alias)
                                            .foregroundColor(.white)
                                            .bold()
                                        
                                        if remote.isDelegate {
                                            // Optional: show a little marker if they're a delegate
                                            Icon(name: .delegate, size: 16, color: Color.foregroundPink)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 8)
                                    .background(Color.black.opacity(0.2))
                                }

                                // 🔹 Expand if user tapped
                                if expandedRemotes[remote.id] == true {
                                    // 1) Pin 'master' first, if it exists
                                    if let masterSHA = remote.heads["master"] {
                                        Button {
                                            // They selected the remote's master
                                            selectedBranch = "(\(alias))/master"
                                            isDropdownVisible = false
                                        } label: {
                                            HStack {
                                                // Use whatever icon you prefer for "master"
                                                Image(systemName: "point.fill.topleft.down.curvedto.point.fill.bottomright")
                                                    .foregroundColor(.gray)
                                                Text("master")
                                                    .foregroundColor(.white)
                                                
                                                Spacer()
                                                
                                                Text(masterSHA.prefix(7))
                                                    .font(.system(.caption, design: .monospaced))
                                                    .foregroundColor(.gray)
                                            }
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 12)
                                        }
                                    }
                                    
                                    // 2) Show other heads besides "master", sorted
                                    let otherHeads = remote.heads
                                        .filter { $0.key != "master" }
                                        .sorted(by: { $0.key < $1.key })
                                    
                                    ForEach(otherHeads, id: \.key) { (branchName, commitSHA) in
                                        Button {
                                            selectedBranch = "(\(alias))/\(branchName)"
                                            isDropdownVisible = false
                                        } label: {
                                            HStack {
                                                // .branch icon at the left
                                                Image(systemName: "branch")
                                                    .foregroundColor(.gray)
                                                
                                                // Branch/Patch name, truncated with trailing ellipsis
                                                Text(branchName)
                                                    .foregroundColor(.white.opacity(0.9))
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                
                                                Spacer()
                                                
                                                // Monospaced commit ID on the right
                                                Text(commitSHA.prefix(7))
                                                    .font(.system(.caption, design: .monospaced))
                                                    .foregroundColor(.gray)
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
                .frame(maxHeight: 300) // Limit height
                .background(Color.fillGhost)
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}

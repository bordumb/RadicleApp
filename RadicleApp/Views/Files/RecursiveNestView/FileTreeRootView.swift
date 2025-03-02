//
//  FileTreeRootView.swift
//  RadicleApp
//
//  Created by bordumb on 24/02/2025.
//

import SwiftUI

struct FileTreeRootView: View {
    let rid: String
    let sha: String
    let path: String?

    @State private var rootNodes: [FileTreeNode] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedFilePath: String? = nil

    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    ProgressView("Loading…")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    // Show each top-level node
                    ForEach(rootNodes) { node in
                        FileTreeNodeView(node: node, onNodeTapped: handleNodeTapped)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(path?.components(separatedBy: "/").last ?? "Files")
            .onAppear {
                fetchRootEntries()
            }
        }
    }

    private func fetchRootEntries() {
        Task {
            do {
                print("Fetching root entries at path: \(path ?? "root")")
                let entries = try await FileService.shared.fetchFileListRecursive(rid: rid, sha: sha, path: path)
                
                // Sort entries: folders first, then files, alphabetically in each group
                let sortedEntries = entries.sorted {
                    if $0.kind == $1.kind {
                        return $0.name < $1.name
                    }
                    return $0.kind == "tree" && $1.kind != "tree"
                }
                
                // Convert them to nodes
                let nodes = sortedEntries.map { FileTreeNode(entry: $0, rid: rid, sha: sha) }
                
                DispatchQueue.main.async {
                    self.rootNodes = nodes
                    self.isLoading = false
                    print("Loaded \(nodes.count) root entries")
                }
            } catch {
                print("Error loading root entries: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    // Handle when a node is tapped
    private func handleNodeTapped(_ node: FileTreeNode) {
        if node.entry.kind == "tree" {
            // It's a folder - toggle its expansion
            node.toggleExpanded()
        } else {
            // It's a file - navigate to file view is handled by the NavigationLink in FileTreeNodeView
            selectedFilePath = node.entry.path
            print("Selected file: \(node.entry.path)")
        }
    }
}

// MARK: - Usage Example (for Previews)
struct FileTreeRootView_Previews: PreviewProvider {
    static var previews: some View {
        FileTreeRootView(rid: "exampleID", sha: "exampleSHA", path: nil)
    }
}

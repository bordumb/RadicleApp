//
//  FileTreeNode.swift
//  RadicleApp
//
//  Created by bordumb on 24/02/2025.
//

import SwiftUI

// MARK: - FileTreeNode
// A tree node that holds a FileEntry plus optional children
class FileTreeNode: ObservableObject, Identifiable {
    var id: String { entry.path }
    let entry: FileEntry
    @Published var children: [FileTreeNode] = []
    @Published var isExpanded: Bool = false
    @Published var isLoading: Bool = false
    @Published var hasLoadedChildren: Bool = false

    // Keep references to identify the repository context
    let rid: String
    let sha: String

    init(entry: FileEntry, rid: String, sha: String) {
        self.entry = entry
        self.rid = rid
        self.sha = sha
    }
    
    // Fetches child nodes if not already loaded
    func fetchChildrenIfNeeded() {
        guard entry.kind == "tree", !hasLoadedChildren else { return }
        isLoading = true
        
        Task {
            do {
                print("Fetching children for \(entry.path)")
                let list = try await FileService.shared.fetchFileList(rid: rid, sha: sha, path: entry.path)
                
                // Convert each FileEntry to a FileTreeNode
                let nodes = list.map { FileTreeNode(entry: $0, rid: rid, sha: sha) }
                
                // Sort nodes: folders first, then files, alphabetically within each group
                let sortedNodes = nodes.sorted {
                    if $0.entry.kind == $1.entry.kind {
                        return $0.entry.name < $1.entry.name
                    }
                    return $0.entry.kind == "tree" && $1.entry.kind != "tree"
                }
                
                DispatchQueue.main.async {
                    self.children = sortedNodes
                    self.hasLoadedChildren = true
                    self.isLoading = false
                    print("Loaded \(sortedNodes.count) items for \(self.entry.path)")
                }
            } catch {
                print("Error loading children for \(entry.path): \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    // Toggle expansion state
    func toggleExpanded() {
        isExpanded.toggle()
        if isExpanded {
            fetchChildrenIfNeeded()
        }
    }
}

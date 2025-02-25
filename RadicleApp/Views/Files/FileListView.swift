//
//  FileListView.swift
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

// MARK: - FileTreeNodeView (Recursive)
struct FileTreeNodeView: View {
    @ObservedObject var node: FileTreeNode
    let onNodeTapped: (FileTreeNode) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Row
            Button(action: {
                // Call the provided action with this specific node
                onNodeTapped(node)
            }) {
                HStack {
                    if node.entry.kind == "tree" {
                        // Folder
                        Image(systemName: node.isExpanded ? "folder.fill.badge.minus" : "folder.fill.badge.plus")
                            .foregroundColor(.yellow)
                    } else {
                        // File
                        Image(systemName: fileIcon(for: node.entry.name))
                            .foregroundColor(.blue)
                    }
                    
                    Text(node.entry.name)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(PlainButtonStyle()) // Avoid default button styling
            
            // Children (if folder is expanded)
            if node.isExpanded && node.entry.kind == "tree" {
                if node.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding(.vertical, 8)
                        Spacer()
                    }
                    .padding(.leading, 20)
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(node.children) { child in
                            // Indent children
                            FileTreeNodeView(node: child, onNodeTapped: onNodeTapped)
                                .padding(.leading, 20)
                        }
                    }
                }
            }
        }
    }
    
    // Return appropriate icon based on file extension
    private func fileIcon(for filename: String) -> String {
        let ext = filename.components(separatedBy: ".").last?.lowercased() ?? ""
        
        switch ext {
            case "swift", "java", "kt", "js", "ts", "py", "rb", "php", "go", "rs", "c", "cpp", "h":
                return "doc.text.fill"
            case "json", "yml", "yaml", "xml", "plist", "toml":
                return "curlybraces"
            case "md", "txt", "rtf":
                return "doc.text"
            case "pdf":
                return "doc.fill"
            case "png", "jpg", "jpeg", "gif", "svg", "webp":
                return "photo"
            case "mp3", "wav", "aac", "flac":
                return "music.note"
            case "mp4", "mov", "avi", "mkv":
                return "film"
            case "zip", "tar", "gz", "7z", "rar":
                return "archivebox"
            default:
                return "doc"
        }
    }
}

// MARK: - FileTreeRootView
// The top-level view for the entire file tree
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
                let entries = try await FileService.shared.fetchFileList(rid: rid, sha: sha, path: path)
                
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
            // It's a file - navigate to file view
            selectedFilePath = node.entry.path
            
            // In a real app, you'd navigate to a file view here
            // For example, with NavigationLink programmatic navigation
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




//
//import SwiftUI
//import Foundation
//
//struct FileListView: View {
//    let rid: String
//    let sha: String
//    
//    @State private var files: [FileEntry] = []
//    @State private var isLoading = true
//    @State private var errorMessage: String?
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isLoading {
//                    ProgressView("Loading files...")
//                } else if let errorMessage = errorMessage {
//                    Text("Error: \(errorMessage)")
//                        .foregroundColor(.red)
//                        .padding()
//                } else {
//                    List(files) { file in
//                        NavigationLink(destination: FileView(rid: rid, sha: sha, path: file.path)) {
//                            Text(file.name)
//                                .foregroundColor(.white)
//                        }
//                        .listRowBackground(Color.black)
//                    }
//                }
//            }
//            .navigationTitle("Files")
//            .background(Color.black.edgesIgnoringSafeArea(.all))
//            .onAppear {
//                fetchFiles()
//            }
//        }
//    }
//    
//    private func fetchFiles() {
//        Task {
//            do {
//                print("🌍 Fetching file list for repo: \(rid) with SHA: \(sha)")
//                let fetchedFiles = try await FileService.shared.fetchFileList(rid: rid, sha: sha)
//                DispatchQueue.main.async {
//                    self.files = fetchedFiles
//                    self.isLoading = false
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Failed to load files: \(error.localizedDescription)"
//                    self.isLoading = false
//                }
//                print("❌ Fetch File List Error: \(error)")
//            }
//        }
//    }
//}

//
//  FileTreeNodeView.swift
//  RadicleApp
//
//  Created by bordumb on 24/02/2025.
//

import SwiftUI

struct FileTreeNodeView: View {
    @ObservedObject var node: FileTreeNode
    let onNodeTapped: (FileTreeNode) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Different view based on whether it's a file or folder
            if node.entry.kind == "tree" {
                // FOLDER: Use a Button for toggling expansion
                Button(action: {
                    onNodeTapped(node)
                }) {
                    HStack {
                        Image(systemName: node.isExpanded ? "folder.fill.badge.minus" : "folder.fill.badge.plus")
                            .foregroundColor(.yellow)
                        Text(node.entry.name)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                // FILE: Use NavigationLink for navigation
                NavigationLink(destination: FileView(rid: node.rid, sha: node.sha, path: node.entry.path)) {
                    HStack {
                        Image(systemName: fileIcon(for: node.entry.name))
                            .foregroundColor(.blue)
                        Text(node.entry.name)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
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

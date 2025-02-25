//
//  FileListView.swift
//  RadicleApp
//
//  Created by bordumb on 25/02/2025.
//

import SwiftUI

struct FileListView: View {
    let rid: String
    let sha: String
    let path: String? // Supports deeper navigation

    @State private var files: [FileEntry] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        List {
            if isLoading {
                ProgressView("Loading files...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ForEach(files, id: \.path) { file in
                    if file.kind == "tree" {
                        // ✅ Navigate into folder
                        NavigationLink(destination: FileListView(rid: rid, sha: sha, path: file.path)) {
                            HStack {
                                Image(systemName: "folder")
                                    .foregroundColor(.yellow)
                                Text(file.name)
                                    .foregroundColor(.white)
                            }
                        }
                    } else {
                        // ✅ Navigate into file
                        NavigationLink(destination: FileView(rid: rid, sha: sha, path: file.path)) {
                            HStack {
                                Image(systemName: "doc.text")
                                    .foregroundColor(.blue)
                                Text(file.name)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(path ?? "Root")
        .onAppear {
            fetchFiles()
        }
    }

    private func fetchFiles() {
        Task {
            do {
                print("🌍 Fetching file list for repo: \(rid), SHA: \(sha), Path: \(path ?? "root")")
                let fetchedFiles = try await FileService.shared.fetchFileList(rid: rid, sha: sha, path: path)
                DispatchQueue.main.async {
                    self.files = fetchedFiles
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load files: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

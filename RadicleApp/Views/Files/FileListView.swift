//
//  FileListView.swift
//  RadicleApp
//
//  Created by bordumb on 24/02/2025.
//

import SwiftUI
import Foundation

struct FileListView: View {
    let rid: String
    let sha: String
    let path: String?  // The path this view is displaying

    @State private var files: [FileEntry] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading files...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(files, id: \.path) { file in
                        // If it's a folder (tree), navigate to FileListView
                        if file.kind == "tree" {
                            NavigationLink(
                                destination: FileListView(
                                    rid: rid,
                                    sha: sha,
                                    path: file.path // Pass subdirectory path
                                )
                            ) {
                                HStack {
                                    Image(systemName: "folder")
                                        .foregroundColor(.yellow)
                                    Text(file.name)
                                        .foregroundColor(.white)
                                }
                            }
                        } else {
                            // It's a blob -> open FileView
                            NavigationLink(
                                destination: FileView(
                                    rid: rid,
                                    sha: sha,
                                    path: file.path
                                )
                            ) {
                                HStack {
                                    Image(systemName: "doc.text")
                                        .foregroundColor(.blue)
                                    Text(file.name)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.black)
                }
            }
            .navigationTitle("Files")
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                fetchFiles()
            }
        }
    }

    private func fetchFiles() {
        Task {
            do {
                print("🌍 Fetching file list for repo: \(rid) with SHA: \(sha) and path: \(path ?? "root")")
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
                print("❌ Fetch File List Error: \(error)")
            }
        }
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

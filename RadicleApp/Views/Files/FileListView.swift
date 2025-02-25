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
    let path: String?
    
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
                    List {
                        ForEach(groupedFiles(), id: \.key) { (key, entries) in
                            Section(header: Text(key).foregroundColor(.gray)) {
                                ForEach(entries, id: \ .path) { file in
                                    if file.kind == "tree" {
                                        NavigationLink(destination: FileListView(rid: rid, sha: sha, path: file.path)) {
                                            HStack {
                                                Image(systemName: "folder")
                                                    .foregroundColor(.yellow)
                                                Text(file.name)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    } else {
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
    
    private func groupedFiles() -> [(key: String, value: [FileEntry])] {
        let grouped = Dictionary(grouping: files) { file in
            let components = file.path.split(separator: "/").dropLast()
            return components.isEmpty ? "Root" : components.joined(separator: "/")
        }
        return grouped.sorted { $0.key < $1.key }
    }
    
    private func fetchFiles() {
        Task {
            do {
                print("🌍 Fetching file list for repo: \(rid) with SHA: \(sha) and Path: \(path ?? "root")")
                let fetchedFiles = try await FileService.shared.fetchFileList(rid: rid, sha: sha)
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

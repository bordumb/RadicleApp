//import SwiftUI
//import MarkdownUI
//import Sourceful
//
//struct FileView: View {
//    let rid: String
//    let sha: String
//    let path: String
//    
//    @State var file: RepoFile?
//    @State private var isLoading = true
//    @State private var errorMessage: String?
//    @State private var currentCommit: CommitResponse?
//
//    var isMarkdown: Bool {
//        path.hasSuffix(".md")
//    }
//
//    var language: Language? {
//        if path.hasSuffix(".swift") { return .swift }
//        if path.hasSuffix(".py")    { return .python }
//        if path.hasSuffix(".js")    { return .javascript }
//        return nil  // Defaults to plain text if no match
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            if isLoading {
//                ProgressView("Loading file...")
//            } else if let file = file {
//                Text(file.name)
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(.white)
//                
//                if let commit = currentCommit {
//                    Text("Commit: \(commit.id.prefix(7)) - \(commit.summary)")
//                        .font(.caption)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//
//                if let content = file.content {
//                    if isMarkdown {
//                        ScrollView {
//                            Markdown(content)
//                                .markdownTheme(.gitHub)
//                                .foregroundStyle(.white)
//                                .padding()
//                        }
//                        .background(Color.black.opacity(0.1))
//                        .cornerRadius(10)
//                    } else if let language = language {
//                        FileCodeView(code: content, language: language)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    } else {
//                        Text(content) // Fallback for unknown file types
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                } else {
//                    Text("No content available or it's a binary file.")
//                        .foregroundColor(.white)
//                }
//            } else if let errorMessage = errorMessage {
//                Text("Error: \(errorMessage)")
//                    .foregroundColor(.red)
//            }
//        }
//        .padding()
//        .background(Color.black.edgesIgnoringSafeArea(.all))
//        .onAppear {
//            fetchFile()
//            fetchCommitHistory()
//        }
//    }
//    
//    private func fetchFile() {
//        Task {
//            do {
//                print("Fetching file with rid: \(rid), sha: \(sha), path: \(path)")
//                let fetchedFile = try await FileService.shared.fetchFileBlob(rid: rid, sha: sha, path: path)
//                
//                DispatchQueue.main.async {
//                    self.file = fetchedFile
//                    self.isLoading = false
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Failed to fetch file: \(error.localizedDescription)"
//                    self.isLoading = false
//                }
//                print("Fetch File Error: \(error)")
//            }
//        }
//    }
//
//    private func fetchCommitHistory() {
//        Task {
//            do {
//                print("Fetching commit history for file: \(path)")
//                let commits = try await FileService.shared.fetchCommitsForFile(rid: rid, path: path)
//                
//                DispatchQueue.main.async {
//                    self.currentCommit = commits.first(where: { $0.id == self.sha }) // ✅ Match exact commit
//                }
//            } catch {
//                print("Failed to fetch commit history for file: \(error)")
//            }
//        }
//    }
//}


import SwiftUI

struct FileView: View {
    let rid: String
    let sha: String
    let path: String
    
    @State var file: RepoFile?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var currentCommit: CommitResponse?
    
    var language: Language {
        if path.hasSuffix(".swift") { return .swift }
        if path.hasSuffix(".py")    { return .python }
        if path.hasSuffix(".js")    { return .javascript }
        return .swift // Default fallback (or you can define `.unknown` if needed)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isLoading {
                ProgressView("Loading file...")
            } else if let file = file {
                
                HStack {
                    Text(file.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)

                    Spacer()
                    
                    if let commit = file.lastCommit {
                        CommitDiffLink(rid: rid, commit: commit)
                    }
                }

                // Show code with highlight + line numbers
                if let content = file.content {
                    FileCodeView(code: content, language: language)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("No content available or it's a binary file.")
                        .foregroundColor(.white)
                }
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchFile()
            fetchFile()
        }
    }
    
    private func fetchFile() {
        Task {
            do {
                print("Fetching file with rid: \(rid), sha: \(sha), path: \(path)")
                let fetchedFile = try await FileService.shared.fetchFileBlob(rid: rid, sha: sha, path: path)
                
                DispatchQueue.main.async {
                    self.file = fetchedFile
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch file: \(error.localizedDescription)"
                    self.isLoading = false
                }
                print("Fetch File Error: \(error)")
            }
        }
    }
}

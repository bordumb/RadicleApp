

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

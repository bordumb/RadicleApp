import SwiftUI

struct FileView: View {
    let rid: String
    let sha: String
    let path: String
    
    @State var file: RepoFile?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
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
                Text(file.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text("Path: \(file.path)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
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

struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FileView(
            rid: "mockRepo",
            sha: "mockSha",
            path: "README.md"
        )
        .onAppear {
            Task {
                let mockFile = RepoFile(
                    name: "README.md",
                    path: "README.md",
                    content: "# Welcome to Radicle!\nThis is a test file.",
                    binary: false
                )
                DispatchQueue.main.async {
                    FileView(rid: "mockRepo", sha: "mockSha", path: "README.md").file = mockFile
                }
            }
        }
    }
}


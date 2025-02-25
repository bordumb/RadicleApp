import SwiftUI

struct FileView: View {
    let rid: String
    let sha: String
    let path: String
    
    @State var file: RepoFile?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
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
                
                ScrollView {
                    Text(file.content ?? "No content available")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
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


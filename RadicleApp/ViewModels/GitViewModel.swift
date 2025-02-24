//
//  GitViewModel.swift
//  RadicleApp
//
//  Created by bordumb on 24/02/2025.
//

import Foundation

class GitViewModel: ObservableObject {
    @Published var gitVersion: String = "Unknown"
    
    func fetchGitVersion() {
        guard let versionPtr = get_git_version() else {
            gitVersion = "Failed to get Git version"
            return
        }

        gitVersion = String(cString: versionPtr)

        // Correctly cast to a mutable pointer and free memory
        free_c_string(UnsafeMutableRawPointer(mutating: versionPtr).assumingMemoryBound(to: CChar.self))
    }

//    func cloneRepository(url: String, path: String) -> Bool {
//        guard let urlCString = url.cString(using: .utf8),
//              let pathCString = path.cString(using: .utf8) else {
//            return false
//        }
//
//        let result = clone_repo(urlCString, pathCString)
//        return result == 0
//    }
    
    func cloneRepository(url: String, path: String) -> Bool {
        guard let urlCString = url.cString(using: .utf8) else {
            print("❌ Invalid URL encoding")
            return false
        }

        let fileManager = FileManager.default
        let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let repoPath = documentDir.appendingPathComponent("repo").path

        // ✅ Ensure the directory exists
        if !fileManager.fileExists(atPath: repoPath) {
            do {
                try fileManager.createDirectory(atPath: repoPath, withIntermediateDirectories: true, attributes: nil)
                print("📁 Created repository directory at \(repoPath)")
            } catch {
                print("❌ Failed to create directory: \(error.localizedDescription)")
                return false
            }
        }

        let result = clone_repo(urlCString, repoPath)

        if result == 0 {
            print("✅ Clone successful! Repository at: \(repoPath)")
            return true
        } else {
            print("❌ Clone failed. Check logs for more details.")
            return false
        }
    }

}

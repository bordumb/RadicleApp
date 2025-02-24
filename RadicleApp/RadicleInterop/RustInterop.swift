//
//  RustInterop.swift
//  RadicleApp
//
//  Created by bordumb on 23/02/2025.
//

import Foundation

class RustInterop {
    static func radAuth(alias: String) -> String {
        guard let cString = alias.cString(using: .utf8) else { return "Invalid alias" }
        
        let resultPointer = rad_auth(cString)
        let result = String(cString: resultPointer!)
        
        free_c_string(UnsafeMutablePointer(mutating: resultPointer)) // ✅ Free memory to avoid leaks
        return result
    }
}

class GitWrapper {
    func getGitVersion() -> String {
        guard let cString = get_git_version() else {
            return "Unknown version"
        }
        
        let version = String(cString: cString)

        // ✅ Ensure `free_c_string` receives an optional pointer
        free_c_string(UnsafeMutablePointer(mutating: cString) ?? nil)

        return version
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
//
    func cloneRepository(url: String, path: String) -> Bool {
            let fileManager = FileManager.default
            let repoURL = URL(fileURLWithPath: path)

            // ✅ Step 1: Check if the directory exists
            if fileManager.fileExists(atPath: path) {
                do {
                    // ✅ Step 2: Remove directory completely
                    try fileManager.removeItem(at: repoURL)
                    print("🗑 Deleted existing repo directory at \(path)")

                    // ✅ Step 3: Ensure directory is actually gone
                    if fileManager.fileExists(atPath: path) {
                        print("❌ Failed to delete directory. Retrying...")
                        return false
                    }
                } catch {
                    print("❌ Failed to delete existing repo: \(error.localizedDescription)")
                    return false
                }
            }

            // ✅ Step 4: Clone repository
            let result = clone_repo(url, path)
            if result == 0 {
                print("✅ Clone successful!")
                return true
            } else {
                print("❌ Clone failed.")
                return false
            }
        }
}



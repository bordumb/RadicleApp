//
//  RepoDownload.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

//import SwiftUI
//
//// Declare the Rust functions
//@_silgen_name("get_git_version")
//func get_git_version() -> UnsafePointer<CChar>?
//
//@_silgen_name("clone_repo")
//func clone_repo(_ url: UnsafePointer<CChar>, _ path: UnsafePointer<CChar>) -> Int32
//
//@_silgen_name("free_c_string")
//func free_c_string(_ ptr: UnsafeMutablePointer<CChar>)
//
//struct ContentView: View {
//    @StateObject private var gitViewModel = GitViewModel()
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Git Version: \(gitViewModel.gitVersion)")
//                .padding()
//
//            Button("Fetch Git Version") {
//                gitViewModel.fetchGitVersion()
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//
//            Button("Clone Repository") {
//                let success = gitViewModel.cloneRepository(
//                    url: "https://github.com/bordumb/wsbtrading",
//                    path: "/tmp/repo"
//                )
//                print(success ? "Clone successful!" : "Clone failed.")
//            }
//            .padding()
//            .background(Color.green)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//        }
//        .padding()
//    }
//}


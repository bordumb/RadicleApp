////
////  RepositoryModel.swift
////  RadicleApp
////
////  Created by bordumb on 16/02/2025.
////
//
//import Foundation
//
//// MARK: - RepoItem
//struct RepoItem: Identifiable, Decodable {
//    let payloads: Payloads
//    let delegates: [DelegateItem]
//    let threshold: Int
//    let visibility: Visibility
//    let rid: String
//    let seeding: Int
//
//    var id: String { rid } // Using rid as unique identifier
//}
//
//// MARK: - Payloads (Dictionary Structure for Different Payload Keys)
//struct Payloads: Codable {
//    let xyzRadicleProject: ProjectPayload?
//    
//    // Custom Decoding to Handle Dynamic Key (like "xyz.radicle.project")
//    enum CodingKeys: String, CodingKey {
//        case xyzRadicleProject = "xyz.radicle.project"
//    }
//}
//
//// MARK: - Project Payload (Nested Data Inside Payloads)
//struct ProjectPayload: Codable {
//    let data: ProjectData
//    let meta: ProjectMeta
//}
//
//// MARK: - Project Data (Contains Repo Details)
//struct ProjectData: Codable {
//    let defaultBranch: String
//    let description: String
//    let name: String
//}
//
//// MARK: - Project Metadata (Contains Commit, Issues, and Patches Info)
//struct ProjectMeta: Codable {
//    let head: String
//    let issues: IssueStats
//    let patches: PatchStats
//}
//
//// MARK: - Issue Stats
//struct IssueStats: Codable {
//    let open: Int
//    let closed: Int
//}
//
//// MARK: - Patch Stats
//struct PatchStats: Codable {
//    let open: Int
//    let draft: Int
//    let archived: Int
//    let merged: Int
//}
//
//// MARK: - Delegate (Holds Contributor Information)
//struct DelegateItem: Codable, Identifiable {
//    let id: String
//    let alias: String?
//}
//
//// MARK: - Visibility (Defines Whether Repo is Public or Private)
//struct Visibility: Codable {
//    let type: String
//}

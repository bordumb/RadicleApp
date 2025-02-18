//
//  ViewController.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Force fetch commits when the view loads
        Task {
            do {
                let commits = try await CommitService.shared.fetchCommits(rid: "rad:z3gqcJUoA1n9HaHKufZs5FCSGazv5")
                print("Fetched \(commits.count) commits on app launch")
            } catch {
                print("Error fetching commits: \(error)")
            }
        }
    }
}

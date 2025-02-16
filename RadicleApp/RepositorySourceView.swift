//
//  RepositorySourceView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

// Placeholder for browsing the repository’s source code.
struct RepositorySourceView: View {
    let rid: String
    let commit: String

    var body: some View {
        Text("Source view for repo \(rid) at commit \(commit)")
            .navigationTitle("Source Code")
            .padding()
    }
}

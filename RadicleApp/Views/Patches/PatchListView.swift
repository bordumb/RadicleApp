//
//  PatchListView.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import SwiftUI

struct PatchListView: View {
    let repoID: String
    @StateObject var viewModel = PatchViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.patches) { patch in
                NavigationLink(destination: PatchDetailView(patch: patch)) {
                    VStack(alignment: .leading) {
                        Text(patch.title)
                            .font(.headline)
                        Text("Author: \(patch.author.alias ?? "Unknown")")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Patches")
            .onAppear {
                viewModel.loadPatches(for: repoID)
            }
        }
    }
}

#Preview {
    let samplePatch1 = Patch(
        id: "12345",
        author: PatchAuthor(id: "did:key:author1", alias: "devUser1"),
        title: "Fix login issue",
        state: PatchState(status: "open"),
        target: "delegates",
        labels: ["bugfix", "UI"],
        merges: [],
        assignees: [],
        revisions: []
    )

    let samplePatch2 = Patch(
        id: "67890",
        author: PatchAuthor(id: "did:key:author2", alias: "devUser2"),
        title: "Improve performance",
        state: PatchState(status: "merged"),
        target: "delegates",
        labels: ["performance", "optimization"],
        merges: [],
        assignees: [],
        revisions: []
    )

    let mockViewModel = PatchViewModel()
    mockViewModel.patches = [samplePatch1, samplePatch2]

    return PatchListView(repoID: "rad:exampleRepo")
        .environmentObject(mockViewModel)
}

//
//  RepositoryCardView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct RepositoryCardView: View {
    let repository: RepoItem
    @State private var activityData: [Int] = Array(repeating: 0, count: 52) // Placeholder until API loads
    @State private var isLoading: Bool = true

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Light grey border
            .background(Color.backgroundFloat).cornerRadius(5) // Dark grey background
            .frame(maxWidth: .infinity, minHeight: 180) // Ensure proper height
            .shadow(color: Color.black.opacity(0.8), radius: 4, x: 0, y: 2) // Adds depth
            .overlay(
                VStack(alignment: .leading, spacing: 8) {

                    // **Top row: Repo Name + Seeders Count**
                    HStack {
                        Text(repository.payloads.xyzRadicleProject?.data.name ?? "Unknown Repo")
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Spacer()

                        // **Seeders Count (Upper Right)**
                        HStack(spacing: 4) {
                            Icon(name: .radicleSeed, size: 16)
                            Text("\(repository.seeding)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        .padding(6)
                        .background(Color.black.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    }

                    // **Description Text**
                    Text(repository.payloads.xyzRadicleProject?.data.description ?? "No description available")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)

                    Spacer(minLength: 6) // Ensures consistent spacing

                    // **Activity Diagram (Fixed Width & Alignment)**
                    if isLoading {
                        ProgressView()
                            .frame(height: 40)
                    } else {
                        VStack {
                            ActivityDiagram(activity: activityData, viewBoxHeight: 40, styleColor: Color(.systemBlue))
                            .frame(height: 40)
                            .padding(.horizontal, 10) // Add horizontal padding
                            .background(Color.black.opacity(0.1)) // Subtle background
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }

                    Spacer()

                    // **Bottom Row: Issues, Patches, Last Update, Repo ID**
                    HStack {

                        Icon(name: .issue, size: 16)
                        Text("\(repository.payloads.xyzRadicleProject?.meta.issues.open ?? 0)")
                            .font(.caption)
                            .foregroundColor(.customWhite)

                        // Patches: GitHub-style Merge Icon
                        Icon(name: .patch, size: 16)
                        Text("\(repository.payloads.xyzRadicleProject?.meta.patches.open ?? 0)")
                            .font(.caption)
                            .foregroundColor(.customWhite)

                        Text("Updated 2 days ago") // Placeholder for now
                            .font(.caption)
                            .foregroundColor(.customWhite)

                        Text("\(repository.rid.prefix(10))...\(repository.rid.suffix(6))")
                            .foregroundColor(.blue)
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
                .padding()
            )
            .onAppear {
                Task {
                    do {
                        let data = try await RepositoryService.shared.fetchActivity(rid: repository.rid)
                        await MainActor.run {
                            self.activityData = data
                            self.isLoading = false
                        }
                    } catch {
                        await MainActor.run {
                            self.isLoading = false
                        }
                    }
                }
            }
    }
}

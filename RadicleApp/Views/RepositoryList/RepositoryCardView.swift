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
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(UIColor.darkGray)) // Dark background
            .frame(maxWidth: .infinity, minHeight: 150) // Ensure proper height
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2) // Adds depth
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    
                    // **Top row: Repo Name + Seeders Count**
                    HStack {
                        Text(repository.payloads.xyzRadicleProject?.data.name ?? "Unknown Repo")
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Spacer()

                        // **Seeders Count**
                        Text("\(repository.seeding) seeders")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                    }

                    // **Description Text**
                    Text(repository.payloads.xyzRadicleProject?.data.description ?? "No description available")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    Spacer(minLength: 4) // Ensures consistent spacing

                    // **Activity Diagram (Fixed Width & Alignment)**
                    if isLoading {
                        ProgressView()
                            .frame(height: 40)
                    } else {
                        ActivityDiagram(
                            activity: activityData, // Directly pass activity data as [Int]
                            viewBoxHeight: 40
                        )
                        .frame(width: 280, height: 40) // Prevent full-width stretching
                        .padding(.top, 4)
                        .padding(.bottom, 8)
                        .background(Color.black.opacity(0.1)) // Subtle background for clarity
                        .clipShape(RoundedRectangle(cornerRadius: 6))
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

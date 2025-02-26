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
            .background(Color(red: 24/255, green: 20/255, blue: 28/255).cornerRadius(5)) // Dark grey background
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
                            Image(systemName: "leaf.fill") // Radicle icon representation
                                .foregroundColor(.white)
                            Text("\(repository.seeding)")
                                .font(.subheadline)
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
                        ActivityDiagram(
                            activity: activityData,
                            viewBoxHeight: 40
                        )
                        .frame(height: 40)
                        .padding(.top, 4)
                        .background(Color.black.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }

                    Spacer()

                    // **Bottom Row: Issues, Patches, Last Update, Repo ID**
                    HStack {

                        Spacer()

                        Image(systemName: "circle.fill") // Solid circle
                                .resizable()
                                .frame(width: 8, height: 8) // Adjust size to be small
                                .foregroundColor(.gray)
                        Text("\(repository.payloads.xyzRadicleProject?.meta.issues.open ?? 0)")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Spacer()

                        // Patches: GitHub-style Merge Icon
                        Image(systemName: "arrow.triangle.branch") // Git-style merge icon
                            .resizable()
                            .frame(width: 12, height: 12) // Adjust size
                            .foregroundColor(.gray)
                        Text("\(repository.payloads.xyzRadicleProject?.meta.patches.open ?? 0)")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text("Updated 2d ago") // Placeholder for now
                            .font(.caption)
                            .foregroundColor(.gray)
                        
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


//
//
//import SwiftUI
//
//struct RepositoryCardView: View {
//    let repository: RepoItem
//    @State private var activityData: [Int] = Array(repeating: 0, count: 52) // Placeholder until API loads
//    @State private var isLoading: Bool = true
//
//    var body: some View {
//        RoundedRectangle(cornerRadius: 12)
//            .fill(Color(UIColor.darkGray)) // Dark background
//            .frame(maxWidth: .infinity, minHeight: 150) // Ensure proper height
//            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2) // Adds depth
//            .overlay(
//                VStack(alignment: .leading, spacing: 8) {
//                    
//                    // **Top row: Repo Name + Seeders Count**
//                    HStack {
//                        Text(repository.payloads.xyzRadicleProject?.data.name ?? "Unknown Repo")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .lineLimit(1)
//
//                        Spacer()
//
//                        // **Seeders Count**
//                        Text("\(repository.seeding) seeders")
//                            .font(.subheadline)
//                            .foregroundColor(.white)
//                            .padding(.trailing, 8)
//                    }
//
//                    // **Description Text**
//                    Text(repository.payloads.xyzRadicleProject?.data.description ?? "No description available")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                        .lineLimit(2)
//                    
//                    Spacer(minLength: 4) // Ensures consistent spacing
//
//                    // **Activity Diagram (Fixed Width & Alignment)**
//                    if isLoading {
//                        ProgressView()
//                            .frame(height: 40)
//                    } else {
//                        ActivityDiagram(
//                            activity: activityData, // Directly pass activity data as [Int]
//                            viewBoxHeight: 40
//                        )
//                        .frame(width: 280, height: 40) // Prevent full-width stretching
//                        .padding(.top, 4)
//                        .padding(.bottom, 8)
//                        .background(Color.black.opacity(0.1)) // Subtle background for clarity
//                        .clipShape(RoundedRectangle(cornerRadius: 6))
//                    }
//                }
//                .padding()
//            )
//            .onAppear {
//                Task {
//                    do {
//                        let data = try await RepositoryService.shared.fetchActivity(rid: repository.rid)
//                        await MainActor.run {
//                            self.activityData = data
//                            self.isLoading = false
//                        }
//                    } catch {
//                        await MainActor.run {
//                            self.isLoading = false
//                        }
//                    }
//                }
//            }
//
//    }
//}

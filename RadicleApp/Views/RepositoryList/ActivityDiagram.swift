//
//  ActivityDiagram.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct WeeklyActivity: Identifiable {
    let id = UUID()
    let date: Date
    let week: Int
    var commits: [Int]
}

import SwiftUI

struct ActivityDiagram: View {
    let activity: [Int] // Raw commit timestamps (UNIX seconds)
    let viewBoxHeight: CGFloat
    let styleColor: Color
    private let strokeWidth: CGFloat = 2
    private let viewBoxWidth: CGFloat = 280
    private let minimalHeight: CGFloat = 5
    private let weeksToShow = 52

    var body: some View {
        let groupedCommits = groupCommitsByWeek(activity)
        let normalizedPoints = normalizeActivity(groupedCommits)

        return ZStack {
            Color.clear

            if !normalizedPoints.isEmpty {
                // ✅ Reverse Fill Gradient
                Path { path in
                    guard let firstPoint = normalizedPoints.first else { return }
                    path.move(to: firstPoint)

                    for point in normalizedPoints.dropFirst() {
                        path.addLine(to: point)
                    }

                    if let lastPoint = normalizedPoints.last {
                        path.addLine(to: CGPoint(x: lastPoint.x, y: viewBoxHeight))
                        path.addLine(to: CGPoint(x: 0, y: viewBoxHeight))
                        path.closeSubpath()
                    }
                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: styleColor.opacity(0), location: 0),    // Oldest week fades out
                            .init(color: styleColor.opacity(0.1), location: 0.5),
                            .init(color: styleColor.opacity(0.2), location: 1)   // Most recent week is vibrant
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )

                // ✅ Reverse Stroke Gradient
                Path { path in
                    guard let firstPoint = normalizedPoints.first else { return }
                    path.move(to: firstPoint)

                    for point in normalizedPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            styleColor.opacity(0.2),  // Oldest week fades out
                            styleColor.opacity(0.8),
                            styleColor.opacity(1.0)   // Most recent week is vibrant
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: strokeWidth, lineJoin: .round)
                )
            } else {
                // If no data, show a straight baseline
                Path { path in
                    path.move(to: CGPoint(x: 0, y: viewBoxHeight))
                    path.addLine(to: CGPoint(x: viewBoxWidth, y: viewBoxHeight))
                }
                .stroke(styleColor, lineWidth: 1)
            }
        }
        .frame(width: viewBoxWidth, height: viewBoxHeight)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }


    /// Groups commit timestamps into weeks
    private func groupCommitsByWeek(_ commits: [Int]) -> [WeeklyActivity] {
        guard !commits.isEmpty else { return [] }

        let sortedCommits = commits.sorted(by: >) // Sort from newest to oldest
        var groupedCommits: [WeeklyActivity] = []
        var groupDate: Date? = nil
        var weekAccumulator = getDaysPassed(from: Date(timeIntervalSince1970: TimeInterval(sortedCommits.first!)), to: Date()) / 7

        for commit in sortedCommits {
            let commitDate = Date(timeIntervalSince1970: TimeInterval(commit))
            let isNewWeek = groupDate == nil || getDaysPassed(from: commitDate, to: groupDate!) > 7

            if isNewWeek {
                let daysPassed = groupDate.map { getDaysPassed(from: commitDate, to: $0) } ?? 0
                groupedCommits.append(WeeklyActivity(
                    date: commitDate,
                    week: weekAccumulator + (daysPassed / 7),
                    commits: [commit] // Initialize with the first commit
                ))
                groupDate = commitDate
                weekAccumulator += daysPassed / 7
            } else {
                // **FIX: Update last week's commits by replacing the struct**
                if let lastIndex = groupedCommits.indices.last {
                    var lastGroup = groupedCommits[lastIndex] // Copy the struct
                    lastGroup.commits.append(commit) // Mutate the copy
                    groupedCommits[lastIndex] = lastGroup // Replace in array
                }
            }
        }

        return groupedCommits
    }


    /// **Normalizes weekly commit activity for visualization**
    private func normalizeActivity(_ activity: [WeeklyActivity]) -> [CGPoint] {
        guard !activity.isEmpty else { return [] }

        let commitCounts = activity.map { $0.commits.count }
        let maxActivity = commitCounts.max() ?? 1
        let minActivity = commitCounts.min() ?? 0
        let range = max(maxActivity - minActivity, 1) // Prevent division by zero
        let widthStep = viewBoxWidth / CGFloat(activity.count)

        return activity.enumerated().map { (i, weeklyData) in
            let count = weeklyData.commits.count
            let normalizedY = viewBoxHeight - ((viewBoxHeight - minimalHeight) * CGFloat(count - minActivity)) / CGFloat(range)
            return CGPoint(x: CGFloat(i) * widthStep, y: normalizedY)
        }
    }

    /// **Calculates days passed between two dates**
    private func getDaysPassed(from startDate: Date, to endDate: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
}

// MARK: - Preview
#Preview {
    ActivityDiagram(
        activity: (0..<365).map { _ in Int.random(in: 1700000000...1702598400) }, // Fake timestamps for last year
        viewBoxHeight: 50,
        styleColor: .blue
    )
}

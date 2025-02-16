//
//  ActivityDiagram.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

struct ActivityDiagram: View {
    let activity: [Int] // Raw activity data (commits per day)
    let viewBoxHeight: CGFloat
    private let strokeWidth: CGFloat = 2
    private let viewBoxWidth: CGFloat = 280 // Prevents full-width stretching
    private let weeksToShow = 12 // Show only the last 12 weeks (3 months)

    var body: some View {
        let recentActivity = Array(activity.suffix(weeksToShow * 7)) // Take last 3 months (in days)
        let weeklyActivity = aggregateActivity(recentActivity)
        let normalizedPoints = normalizeActivity(weeklyActivity)

        return ZStack {
            // Background color matching the card
            Color(UIColor.darkGray)
            
            // White line graph
            Path { path in
                guard let firstPoint = normalizedPoints.first else { return }
                path.move(to: firstPoint)

                for point in normalizedPoints.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(Color.white, lineWidth: strokeWidth)
        }
        .frame(width: viewBoxWidth, height: viewBoxHeight)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    /// Aggregates daily activity into weekly buckets (each bucket represents 1 week)
    private func aggregateActivity(_ data: [Int]) -> [Int] {
        let bucketSize = 7 // Each bucket represents 7 days (1 week)
        let weeklyData = stride(from: 0, to: data.count, by: bucketSize).map { index in
            data[index..<min(index + bucketSize, data.count)].reduce(0, +) // Sum commits per week
        }

        print("🔹 [DEBUG] Raw Daily Activity Data (Last \(weeksToShow * 7) days):", data)
        print("🔹 [DEBUG] Aggregated Weekly Activity Data:", weeklyData)

        return weeklyData
    }

    /// Normalizes the aggregated weekly activity for visualization
    private func normalizeActivity(_ activity: [Int]) -> [CGPoint] {
        guard !activity.isEmpty else { return [] }
        
        let maxActivity = activity.max() ?? 1
        let minActivity = activity.min() ?? 0
        let range = maxActivity - minActivity

        // Prevent division by zero and avoid flat lines
        let heightScale = range > 0 ? range : 1
        let widthStep = viewBoxWidth / CGFloat(activity.count)

        let points = activity.enumerated().map { (i, count) in
            let normalizedY = viewBoxHeight - ((viewBoxHeight - 5) * CGFloat(count - minActivity)) / CGFloat(heightScale)
            return CGPoint(x: CGFloat(i) * widthStep, y: normalizedY)
        }

        print("🔹 [DEBUG] Normalized Points for Graph:", points)

        return points
    }
}

// MARK: - Preview
#Preview {
    ActivityDiagram(
        activity: (0..<180).map { _ in Int.random(in: 0...20) }, // Last 6 months of daily activity
        viewBoxHeight: 40
    )
}

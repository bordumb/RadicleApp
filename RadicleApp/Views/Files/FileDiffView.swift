//
//  FileDiffView.swift
//  RadicleApp
//
//  Created by bordumb on 25/02/2025.
//

import SwiftUI

struct FileDiffView: View {
    let file: DiffFile
    @State private var isExpanded = false // Track collapse state

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // 🔹 File Header (Clickable to Expand/Collapse)
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)

                    Text(file.path)
                        .font(.system(.body, design: .monospaced))
                        .bold()
                        .foregroundColor(.white)

                    Spacer()

                    Text(file.status.capitalized)
                        .font(.caption)
                        .padding(4)
                        .background(file.statusColor)
                        .cornerRadius(4)
                }
                .padding(.vertical, 10) // Keep vertical padding
                .contentShape(Rectangle()) // Make button tappable in full area
            }
            .buttonStyle(PlainButtonStyle()) // Remove default button styling

            // 🔹 Expandable Content (Diff Hunks)
            if isExpanded {
                if let diff = file.diff {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(diff.hunks, id: \.header) { hunk in
                            FileHunkView(hunk: hunk)
                        }
                    }
                    .padding(.top, 5)
                } else {
                    Text("No diff available.")
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                }
            }
        }
        .frame(maxWidth: .infinity) // 🛠️ Make it fully expand horizontally
        .background(Color.black.opacity(0.2))
        .overlay( // Only top & bottom border, no left/right
            VStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1) // Thin top border
                Spacer()
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1) // Thin bottom border
            }
        )
        .padding(.vertical, 5) // Keep vertical spacing
}
}

// ✅ Extracted View for Hunks
struct FileHunkView: View {
    let hunk: DiffHunk

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(hunk.header)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.gray)

            ForEach(hunk.lines, id: \.line) { line in
                Text(line.line)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(line.typeColor)
                    .padding(.leading, 10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.15))
    }
}

// ✅ Break Out Status Color Logic
extension DiffFile {
    var statusColor: Color {
        switch status {
        case "added": return Color.green.opacity(0.3)
        case "modified": return Color.blue.opacity(0.3)
        case "deleted": return Color.red.opacity(0.3)
        default: return Color.gray.opacity(0.3)
        }
    }
}

// ✅ Break Out Type Color Logic
extension DiffLine {
    var typeColor: Color {
        switch type {
        case "addition": return Color.green
        case "deletion": return Color.red
        default: return Color.white
        }
    }
}

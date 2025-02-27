//
//  FileDiffView.swift
//  RadicleApp
//
//  Created by bordumb on 25/02/2025.
//

import SwiftUI

class DiffFileViewModel: ObservableObject {
    @Published var isExpanded: Bool = false
}

struct FileDiffView: View {
    let file: DiffFile
    @StateObject private var viewModel = DiffFileViewModel() // 🔥 Tracks expansion without slow re-renders

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button(action: {
                withAnimation {
                    viewModel.isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: viewModel.isExpanded ? "chevron.down" : "chevron.right")
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
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            if viewModel.isExpanded {
                if let hunks = file.diff?.hunks, !hunks.isEmpty {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(hunks, id: \.header) { hunk in
                            FileHunkView(hunk: hunk)
                        }
                    }
                    .padding(.top, 5)
                } else {
                    Text("No changes in this file")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(.top, 5)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.2))
        .overlay(
            VStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1)
                Spacer()
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1)
            }
        )
        .padding(.vertical, 5)
    }
}


// Extracted View for Hunks
struct FileHunkView: View {
    let hunk: DiffHunk

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(hunk.header)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.gray)

            if !hunk.lines.isEmpty {
                ForEach(hunk.lines, id: \.line) { line in
                    HStack {
                        Text(line.line)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(line.typeColor)
                        Spacer()
                    }
                    .padding(.leading, 10)
                }
            } else {
                Text("No changes in this hunk")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.15))
        .cornerRadius(6)
    }
}

// Extracted Status Color Logic for File Status
extension DiffFile {
    var statusColor: Color {
        switch status.lowercased() {
        case "added": return Color.green.opacity(0.3)
        case "modified": return Color.blue.opacity(0.3)
        case "deleted": return Color.red.opacity(0.3)
        default: return Color.gray.opacity(0.3)
        }
    }
}

// Extracted Type Color Logic for Diff Line Type
extension DiffLine {
    var typeColor: Color {
        switch type {
        case "addition": return Color.green
        case "deletion": return Color.red
        default: return Color.white
        }
    }
}

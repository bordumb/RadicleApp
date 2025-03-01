//
//  TestFileDiffView.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import SwiftUI

// 🔹 ViewModel for Expandable Sections
class DiffFileViewModel: ObservableObject {
    @Published var isExpanded: Bool = false
}

struct TestFileDiffView: View {
    let diffFile: DiffFile
    let language: CodeLanguage

    @StateObject private var viewModel = DiffFileViewModel() // ✅ Track expand state

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // 🔹 File Header
            Button(action: {
                withAnimation {
                    viewModel.isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: viewModel.isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)

                    Text(diffFile.path)
                        .font(.system(.body, design: .monospaced))
                        .bold()
                        .foregroundColor(.white)

                    Spacer()

                    Text(diffFile.status.capitalized)
                        .font(.caption)
                        .padding(4)
                        .background(diffFile.statusColor)
                        .cornerRadius(4)
                }
                .padding(.vertical, 10)
                .contentShape(Rectangle()) // ✅ Expandable click area
            }
            .buttonStyle(PlainButtonStyle())

            // 🔹 Expanded Section (Shows Code Diff when expanded)
            if viewModel.isExpanded {
                if let hunks = diffFile.diff?.hunks, !hunks.isEmpty {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(hunks.indices, id: \.self) { index in
                            let hunk = hunks[index]

                            FileHunkView(hunk: hunk, language: language)
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
        .background(Color.black.opacity(0.2))
        .cornerRadius(10)
        .padding(.vertical, 5)
    }
}

// 🔹 Improved FileHunkView (for rendering each diff section)
struct FileHunkView: View {
    let hunk: DiffHunk
    let language: CodeLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(hunk.header)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.gray)

            if !hunk.lines.isEmpty {
                VStack(spacing: 0) {
                    ForEach(hunk.lines.indices, id: \.self) { lineIndex in
                        let line = hunk.lines[lineIndex]

                        HStack(alignment: .top, spacing: 0) {
                            // 🔹 Old Line Number (Always 3 characters wide)
                            Text(line.lineNoOld.map { String(format: "%3d", $0) } ?? "   ")
                                .foregroundColor(.gray)
                                .frame(width: 40, alignment: .trailing) // ✅ Fixed width
                                .opacity(line.type == "addition" ? 0 : 1) // Hide for added lines
                                .padding(.vertical, 4)

                            // 🔹 New Line Number (Always 3 characters wide)
                            Text(line.lineNoNew.map { String(format: "%3d", $0) } ?? "   ")
                                .foregroundColor(.gray)
                                .frame(width: 40, alignment: .trailing) // ✅ Fixed width
                                .opacity(line.type == "deletion" ? 0 : 1) // Hide for deleted lines
                                .padding(.vertical, 4)

                            ZStack {
                                // 🔹 Background color based on type
                                Rectangle()
                                    .fill(line.type == "addition" ? Color.green.opacity(0.3) :
                                          line.type == "deletion" ? Color.red.opacity(0.3) :
                                          Color.clear)
                                    .cornerRadius(4)
                                    .frame(maxWidth: .infinity, minHeight: 24)

                                // 🔹 Code Content
                                Text(line.line)
                                    .font(.system(.body, design: .monospaced)) // ✅ Monospaced font
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                }
            } else {
                Text("No changes in this hunk")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
            }
        }
        .padding()
        .background(SwiftUI.Color.black.opacity(0.15))
        .cornerRadius(6)
    }
}

// 🔹 Color Coding for File Status
extension DiffFile {
    var statusColor: SwiftUI.Color {
        switch status.lowercased() {
        case "added": return Color.green.opacity(0.3)
        case "modified": return Color.blue.opacity(0.3)
        case "deleted": return Color.red.opacity(0.3)
        default: return Color.gray.opacity(0.3)
        }
    }
}

#Preview {
    let sampleHunk = DiffHunk(
        header: "@@ -10,6 +10,7 @@",
        lines: [
            // Removed function (Old Code)
            DiffLine(type: "deletion", line: "func greet(name: String) -> String {", lineNoOld: 10, lineNoNew: nil),
            DiffLine(type: "deletion", line: "    return \"Hello, \" + name", lineNoOld: 11, lineNoNew: nil),
            DiffLine(type: "deletion", line: "}", lineNoOld: 12, lineNoNew: nil),

            // Added function (New Code)
            DiffLine(type: "addition", line: "func greet(name: String) -> String {", lineNoOld: nil, lineNoNew: 10),
            DiffLine(type: "addition", line: "    return \"Hello, \\(name)! Welcome!\"", lineNoOld: nil, lineNoNew: 11),
            DiffLine(type: "addition", line: "}", lineNoOld: nil, lineNoNew: 12),
        ],
        old: HunkRange(start: 10, end: 12),
        new: HunkRange(start: 10, end: 12)
    )

    let sampleDiffFile = DiffFile(
        status: "modified",
        path: "Greeting.swift",
        diff: FileDiff(type: "swift", hunks: [sampleHunk], eof: nil),
        old: DiffObject(oid: "old_sha", mode: "blob"),
        new: DiffObject(oid: "new_sha", mode: "blob")
    )

    TestFileDiffView(
        diffFile: sampleDiffFile,
        language: languageForFile("Greeting.swift")
    )
}

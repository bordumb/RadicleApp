//
//  CodeDiffView.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import SwiftUI
import Sourceful

struct CodeDiffView: UIViewRepresentable {
    let hunk: DiffHunk
    let language: CodeLanguage

    func makeUIView(context: Context) -> SyntaxTextView {
        let textView = SyntaxTextView()
        textView.theme = DefaultSourceCodeTheme()
        
        // ✅ Monospaced Font for Syntax Highlighting
        textView.contentTextView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.contentTextView.textColor = UIColor.white
        textView.contentTextView.backgroundColor = UIColor.black
        textView.contentTextView.isEditable = false
        textView.delegate = context.coordinator

        textView.text = formattedDiff()
        return textView
    }

    func updateUIView(_ uiView: SyntaxTextView, context: Context) {
        let newText = formattedDiff()
        if uiView.text != newText {
            uiView.text = newText
            uiView.setNeedsDisplay()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, language: language)
    }

    class Coordinator: NSObject, SyntaxTextViewDelegate {
        var parent: CodeDiffView
        var lexer: Lexer

        init(_ parent: CodeDiffView, language: CodeLanguage) {
            self.parent = parent
            switch language {
            case .swift:
                self.lexer = SwiftLexer()
            case .python:
                self.lexer = Python3Lexer()
            case .javascript:
                self.lexer = JavaScriptLexer()
            default:
                self.lexer = BasicLexer() // Uses an empty lexer for unknown types
            }
        }

        func lexerForSource(_ source: String) -> Lexer {
            return lexer
        }
    }

    class BasicLexer: Lexer {
        func getSavannaTokens(input: String) -> [Token] { return [] }
    }

    // ✅ Formats Diff with Line Numbers, Highlighting, and Syntax Coloring
    private func formattedDiff() -> String {
        return hunk.lines.map { line in
            let lineNumberOld = line.lineNoOld.map { String(format: "%3d", $0) } ?? "   "
            let lineNumberNew = line.lineNoNew.map { String(format: "%3d", $0) } ?? "   "
            let prefix: String

            switch line.type {
            case "addition": prefix = "+ "
            case "deletion": prefix = "- "
            default: prefix = "  "
            }

            return "\(lineNumberOld) \(lineNumberNew) \(prefix)\(line.line)"
        }.joined(separator: "\n")
    }
}






//
//// GitHub-Style Code Diff View with Line Numbers & Syntax Highlighting
//struct CodeDiff 
//    let hunk: DiffHunk
//    let language: CodeLanguage
//
//    func makeUIView(context: Context) -> SyntaxTextView {
//        let textView = SyntaxTextView()
//        textView.theme = DefaultSourceCodeTheme()
//        
//        // 🔹 Explicitly set text color and font
//        textView.contentTextView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
//        
//        textView.contentTextView.backgroundColor = .black
//        textView.contentTextView.isEditable = false
//        textView.delegate = context.coordinator
//
//        let diffText = formattedDiff()
//        print("📜 Setting text in SyntaxTextView:\n\(diffText)") // Debug output
//        textView.text = diffText
//
//        return textView
//    }
//
//    func updateUIView(_ uiView: SyntaxTextView, context: Context) {
//        let diffText = formattedDiff()
//        if uiView.text != diffText {
//            print("Updating UI with new diff text:", diffText) // Debugging print
//            uiView.text = diffText
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self, language: language)
//    }
//
//    class Coordinator: NSObject, SyntaxTextViewDelegate {
//        var parent: CodeDiffView
//        var lexer: Lexer
//
//        init(_ parent: CodeDiffView, language: CodeLanguage) {
//            self.parent = parent
//            switch language {
//            case .swift:
//                self.lexer = SwiftLexer()
//            default:
//                self.lexer = BasicLexer()
//            }
//        }
//
//        func didChangeText(_ syntaxTextView: SyntaxTextView) {}
//        func didChangeSelectedRange(_ syntaxTextView: SyntaxTextView, selectedRange: NSRange) {}
//        func lexerForSource(_ source: String) -> Lexer { return lexer }
//    }
//
//    class BasicLexer: Lexer {
//        func getSavannaTokens(input: String) -> [Token] { return [] }
//    }
//
//    // ✅ Formats Diff with Line Numbers & Color Coding
//    private func formattedDiff() -> String {
//        guard !hunk.lines.isEmpty else {
//            print("⚠️ No lines found in hunk")
//            return "No changes found."
//        }
//
//        let diffText = hunk.lines.map { line in
//            let prefix: String
//            switch line.type {
//            case "addition": prefix = "+ "
//            case "deletion": prefix = "- "
//            default: prefix = "  "
//            }
//            return "\(line.lineNoOld ?? line.lineNoNew ?? 0) \(prefix)\(line.line)"
//        }.joined(separator: "\n")
//
//        print("✅ Formatted Diff:\n\(diffText)") // 🔍 Debug output
//        return diffText
//    }
//
//}
//
//
//// 🔹 Color Coding for File Status
//extension DiffFile {
//    var statusColor: SwiftUI.Color {
//        switch status.lowercased() {
//        case "added": return SwiftUI.Color.green.opacity(0.3)
//        case "modified": return SwiftUI.Color.blue.opacity(0.3)
//        case "deleted": return SwiftUI.Color.red.opacity(0.3)
//        default: return SwiftUI.Color.gray.opacity(0.3)
//        }
//    }
//}

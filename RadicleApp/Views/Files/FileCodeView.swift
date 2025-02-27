//
//  FileCodeView.swift
//  RadicleApp
//
//  Created by bordumb on 25/02/2025.
//

import SwiftUI
import Sourceful

struct FileCodeView: UIViewRepresentable {
    let code: String
    let language: Language

    func makeUIView(context: Context) -> SyntaxTextView {
        let textView = SyntaxTextView()
        textView.theme = DefaultSourceCodeTheme()
        textView.contentTextView.textColor = .white
        textView.contentTextView.backgroundColor = .black
        textView.contentTextView.isEditable = false
        textView.delegate = context.coordinator
        textView.text = code
        return textView
    }

    func updateUIView(_ uiView: SyntaxTextView, context: Context) {
        uiView.text = code
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, language: language)
    }
    
    class BasicLexer: Lexer {
        func getSavannaTokens(input: String) -> [Token] {
            return []
        }
    }

    class Coordinator: NSObject, SyntaxTextViewDelegate {
        var parent: FileCodeView
        var lexer: Lexer

        init(_ parent: FileCodeView, language: Language) {
            self.parent = parent
            switch language {
            case .swift:
                self.lexer = SwiftLexer() // ✅ Native Swift support
            default:
                self.lexer = BasicLexer() // ✅ Placeholder for Python & JavaScript
            }
        }

        // Required by SyntaxTextViewDelegate
        func didChangeText(_ syntaxTextView: SyntaxTextView) {
            // No-op for read-only display
        }

        func didChangeSelectedRange(_ syntaxTextView: SyntaxTextView, selectedRange: NSRange) {
            // No-op for read-only display
        }

        func lexerForSource(_ source: String) -> Lexer {
            return lexer
        }
    }
}

// Enum for supported languages
enum Language {
    case swift
    case python
    case javascript
}


//
//  Code.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import Foundation

/// Enum representing supported programming languages for syntax highlighting.
enum CodeLanguage {
    case swift
    case python
    case javascript
}

/// Determines the programming language based on the file extension.
func languageForFile(_ path: String) -> CodeLanguage {
    if path.hasSuffix(".swift") { return .swift }
    if path.hasSuffix(".py")    { return .python }
    if path.hasSuffix(".js")    { return .javascript }
    return .swift // Default fallback
}

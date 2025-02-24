//
//  RustInterop.swift
//  RadicleApp
//
//  Created by bordumb on 23/02/2025.
//

import Foundation

class RustInterop {
    static func radAuth(alias: String) -> String {
        guard let cString = alias.cString(using: .utf8) else { return "Invalid alias" }
        
        let resultPointer = rad_auth(cString)
        let result = String(cString: resultPointer!)
        
        free(resultPointer) // Free memory to avoid leaks
        return result
    }
}

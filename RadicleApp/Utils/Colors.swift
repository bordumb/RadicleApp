//
//  Colors.swift
//  RadicleApp
//
//  Created by bordumb on 26/02/2025.
//

import SwiftUI

extension Color {
    static let customWhite = Color(red: 250 / 255, green: 249 / 255, blue: 251 / 255)
    static let foregroundContrast = Color(hex: "#f9f9fb")
    static let backgroundDefault = Color(hex: "#0a0d10") // Dark background
    static let backgroundFloat = Color(hex: "#14151a") // Floating elements background
    static let fillGhost = Color(hex: "#24252d")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6: // RGB (without alpha)
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        default:
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }
}

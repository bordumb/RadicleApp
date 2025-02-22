//
//  SettingsMenu.swift
//  RadicleApp
//
//  Created by bordumb on 18/02/2025.
//

import SwiftUI

struct SettingsMenu: View {
    @Binding var isPresented: Bool
    @State private var selectedTheme: ThemeMode = .dark
    @State private var selectedFont: CodeFont = .jetbrains

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Settings")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) { isPresented = false }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 5)

            // About Link
            Link("About radicle.xyz", destination: URL(string: "https://radicle.xyz")!)
                .foregroundColor(.blue)

            // Theme Picker
            Picker("Theme", selection: $selectedTheme) {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    Label(mode.rawValue, systemImage: mode.icon)
                }
            }
            .pickerStyle(.menu)

            // Code Font Picker
            Picker("Code Font", selection: $selectedFont) {
                ForEach(CodeFont.allCases, id: \.self) { font in
                    Text(font.rawValue)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .frame(width: 300)
        .background(Color.black)
        .cornerRadius(15)
        .shadow(radius: 10)
        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 180)
    }
}

// MARK: - Theme Mode Enum
enum ThemeMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

// MARK: - Code Font Enum
enum CodeFont: String, CaseIterable {
    case jetbrains = "JetBrains Mono"
    case system = "System"
}

// MARK: - SwiftUI Preview
struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu(isPresented: .constant(true))
            .background(Color.gray.opacity(0.5)) // For better contrast in preview
    }
}

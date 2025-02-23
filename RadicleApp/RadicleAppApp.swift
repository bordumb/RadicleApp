//
//  RadicleAppApp.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import SwiftUI

@main
struct RadicleApp: App {
    @StateObject private var apiClient = APIClient.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(apiClient) // Inject into the environment
        }
    }
}

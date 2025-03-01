//
//  ContentView.swift
//  RadicleApp
//
//  Created by bordumb on 23/02/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var apiClient: APIClient
    @State private var nodeInfo: NodeInfo?  // Holds fetched node data
    @State private var isLoading = true  // Loading state

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.backgroundDefault)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        
        TopNavigationBar()

            // Main Content
            TabView {
                RepositoryListView()
                    .tabItem {
                        VStack {
                            Image("home_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Home")
                        }
                    }

                SettingsView()
                    .tabItem {
                        VStack {
                            Icon(name: .settings, size: 24)
                            Text("Settings")
                        }
                    }
            }
            .tint(.gray)
            .edgesIgnoringSafeArea(.bottom)
    }
}


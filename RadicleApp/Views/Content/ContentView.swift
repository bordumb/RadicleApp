//
//  ContentViewMain.swift
//  RadicleApp
//
//  Created by bordumb on 23/02/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var apiClient: APIClient

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {

        VStack {

            TopNavigationBar()  // Wrapping the existing structure

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
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                    }
            }
            .tint(.gray)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// Example for importing Rust functions
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Text("Hello, Radicle!")
//                .padding()
//
//            Button("Test Rust Function") {
//                RustInterop.testRust()
//            }
//        }
//    }
//}

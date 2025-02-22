//
//  ContentView.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.

import SwiftUI

struct ContentView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        VStack {
            // Persistent Server Selector at the top
            ServerSelectorView()
                .padding(.horizontal)
                .padding(.top, 8)

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
                
                InfoSheetView()
                    .tabItem {
                        Label("Info", systemImage: "info.circle.fill")
                    }
                
                Text("Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .tint(.gray)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// MARK: - Info Sheet View
struct InfoSheetView: View {
    var body: some View {
        VStack {
            Text("Info")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("This is some basic information about the app.")
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

//
//  NodeInfoView.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import SwiftUI

struct NodeInfoView: View {
    @State private var nodeInfo: NodeInfo?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isLoading {
                ProgressView("Loading Node Info...")
            } else if let nodeInfo = nodeInfo {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Alias (Fixed Height)
                    if let config = nodeInfo.config {
                        VStack {
                            Text(config.alias)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 30)  // Prevents shifting
                        
                        // Connection String (Fixed Height)
                        if let connectionString = buildConnectionString(from: nodeInfo) {
                            VStack {
                                CopyTextView(
                                    fullText: connectionString,
                                    displayText: formattedConnection(connectionString)
                                )
                                .fixedSize(horizontal: false, vertical: true)  // Ensures proper text wrapping
                                .multilineTextAlignment(.leading)  // Keeps text aligned properly
                            }
                        }

                    } else {
                        VStack {
                            Text("⚠️ No config data available")
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                        .frame(height: 30)  // Keeps space even if config is missing
                    }

                    // Description (Fixed Height)
                    VStack {
                        Text(nodeInfo.description)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 30)  // ✅ Prevents shifting
                    
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                .padding(.horizontal)
            } else if let error = errorMessage {
                Text("⚠️ \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            fetchNodeInfo()
        }
    }

    // ✅ Function to Build the Connection String
    private func buildConnectionString(from nodeInfo: NodeInfo) -> String? {
        guard let externalAddress = nodeInfo.config?.externalAddresses.first else {
            return nil
        }
        return "\(nodeInfo.id)@\(externalAddress)"
    }

    private func formattedConnection(_ connection: String) -> String {
        guard let atIndex = connection.firstIndex(of: "@") else { return connection }
        
        let beforeAt = String(connection[..<atIndex])  // Everything before "@"
        let afterAt = String(connection[atIndex...])   // Everything including "@"

        let firstPart = String(beforeAt.prefix(6))
        let lastPart = String(beforeAt.suffix(6))

        // Ensure the @ moves to the next line
        return "\(firstPart)...\(lastPart)\n\(afterAt)"
    }

    
    private func fetchNodeInfo() {
        Task {
            do {
                print("🔄 Fetching node info...")
                let fetchedNodeInfo = try await NodeService.shared.fetchNodeInfo()
                DispatchQueue.main.async {
                    self.nodeInfo = fetchedNodeInfo
                    self.isLoading = false
                    self.errorMessage = nil
                }
                print("✅ Node info loaded successfully.")
            } catch {
                    print("❌ Error fetching node info: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = error.localizedDescription  // Convert Error to String
                    }
            }
        }
    }
}

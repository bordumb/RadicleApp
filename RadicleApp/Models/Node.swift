//
//  Node.swift
//  RadicleApp
//
//  Created by bordumb on 27/02/2025.
//

import Foundation

// MARK: - Root NodeInfo Model
struct NodeInfo: Codable {
    let id: String
    let agent: String
    let config: NodeConfig?
    let state: String
    let description: String
}

// MARK: - Node Configuration
struct NodeConfig: Codable {
    let alias: String
    let listen: [String]
    let peers: Peers
    let connect: [String]
    let externalAddresses: [String]
    let network: String
    let log: String
    let relay: String
    let limits: Limits
    let workers: Int
    let seedingPolicy: SeedingPolicy
}

// MARK: - Peers
struct Peers: Codable {
    let type: String
}

// MARK: - Limits
struct Limits: Codable {
    let routingMaxSize: Int
    let routingMaxAge: Int
    let gossipMaxAge: Int
    let fetchConcurrency: Int
    let maxOpenFiles: Int
    let rate: Rate
    let connection: ConnectionLimits
}

// MARK: - Rate
struct Rate: Codable {
    let inbound: RateConfig
    let outbound: RateConfig
}

struct RateConfig: Codable {
    let fillRate: Double
    let capacity: Int
}

// MARK: - Connection Limits
struct ConnectionLimits: Codable {
    let inbound: Int
    let outbound: Int
}

// MARK: - Seeding Policy
struct SeedingPolicy: Codable {
    let `default`: String
    let scope: String?  // Make "scope" optional to prevent decoding errors
}


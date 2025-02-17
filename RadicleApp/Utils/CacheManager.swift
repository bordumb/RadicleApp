//
//  CacheManager.swift
//  RadicleApp
//
//  Created by bordumb on 17/02/2025.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private init() {}

    private let cache = NSCache<NSString, CachedData>()

    func storeData(_ data: Data, forKey key: String, expiresIn seconds: TimeInterval = 300) {
        let expiryDate = Date().addingTimeInterval(seconds)
        let cachedData = CachedData(data: data, expiryDate: expiryDate)
        cache.setObject(cachedData, forKey: key as NSString)
    }

    func getData(forKey key: String) -> Data? {
        if let cachedData = cache.object(forKey: key as NSString), cachedData.expiryDate > Date() {
            return cachedData.data
        }
        cache.removeObject(forKey: key as NSString) // Remove expired data
        return nil
    }
}

// Helper struct to track expiry
class CachedData: NSObject {
    let data: Data
    let expiryDate: Date

    init(data: Data, expiryDate: Date) {
        self.data = data
        self.expiryDate = expiryDate
    }
}

//
//  StorageManager.swift
//  iOSDepartment
//
//  Created by Александр Строев on 25.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import Foundation
import KeychainAccess

extension StorageManager {
    
    enum Key: String {
        case token
    }
    
    var token: String {
        set {
            set(newValue, for: Key.token)
        }
        get {
            return get(for: Key.token) ?? ""
        }
    }
}

final class StorageManager {
    
    private static var uniqueInstance: StorageManager?
    
    private init() {}
    
    static var shared: StorageManager {
        if uniqueInstance == nil {
            uniqueInstance = StorageManager()
        }
        return uniqueInstance!
    }
    
    private var keychain: Keychain {
        guard let service = Bundle.main.infoDictionary?[String(kCFBundleIdentifierKey)] as? String else {
            fatalError()
        }
        
        return Keychain(service: service)
            .accessibility(.whenUnlockedThisDeviceOnly)
    }
    
    private func set<T: Encodable>(_ value: T?, for key: Key) {
        guard let value = value else {
            delete(for: key)
            return
        }
        do {
            let data = try JSONEncoder().encode(value)
            try keychain.set(data, key: key.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func get<T: Decodable>(for key: Key) -> T? {
        do {
            guard let data = try keychain.getData(key.rawValue) else { return nil }
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    private func delete(for key: Key) {
        do {
            try keychain.remove(key.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

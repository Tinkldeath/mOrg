//
//  ManagerFactory.swift
//  mOrganization
//
//  Created by Dima on 18.11.23.
//

import Foundation


protocol ManagerFactory {
    func getAuthManager() -> AuthManager
    func getStorageManager() -> StorageManager
}


final class DefaultManagerFactory: ManagerFactory {
    
    private let authManager = DefaultAuthManager()
    private let storageManager = UserDefaultsStorageManager()
    
    func getAuthManager() -> AuthManager {
        return authManager
    }
    
    func getStorageManager() -> StorageManager {
        return storageManager
    }
    
}

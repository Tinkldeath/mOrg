//
//  StorageManager.swift
//  mOrganization
//
//  Created by Dima on 18.11.23.
//

import Foundation


protocol StorageManager {
    var systemUser: SystemUser? { get }
    func storeSystemUser(_ user: SystemUser?)
}


final class UserDefaultsStorageManager: StorageManager {
    
    var systemUser: SystemUser? {
        guard let candidate = UserDefaults.standard.object(forKey: Constants.kSystemUser) as? Data else { return nil }
        guard let user = try? JSONDecoder().decode(SystemUser.self, from: candidate) else { return nil }
        return user
    }
    
    func storeSystemUser(_ user: SystemUser?) {
        guard let user = user else {
            UserDefaults.standard.set(nil, forKey: Constants.kSystemUser)
            return
        }
        guard let serializedUser = try? JSONEncoder().encode(user) else { return }
        UserDefaults.standard.set(serializedUser, forKey: Constants.kSystemUser)
    }
    
}

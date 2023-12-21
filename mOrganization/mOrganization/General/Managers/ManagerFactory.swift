//
//  ManagerFactory.swift
//  mOrganization
//
//  Created by Dima on 18.11.23.
//

import Foundation

protocol ManagerFactory {
    var authManager: AuthManager { get }
    var businessManager: BusinessManager { get }
    var employeeManager: EmployeeManager { get }
    var mailManager: MailManager { get }
}

final class DefaultManagerFactory: ManagerFactory {
    
    private init() {}
    
    static let shared = DefaultManagerFactory()
    
    let authManager: AuthManager = DefaultAuthManager()
    
    let businessManager: BusinessManager = DefaultBusinessManager(FirebaseDataStore.shared)
    
    let employeeManager: EmployeeManager = DefaultEmployeeManager(FirebaseDataStore.shared)
    
    let mailManager: MailManager = DefaultMailManager(FirebaseDataStore.shared)
}

//
//  SystemUser.swift
//  mOrganization
//
//  Created by Dima on 18.11.23.
//

import Foundation
import FirebaseFirestore


struct SystemUser: Codable {
    var uid: String
    var type: UserRole
}


extension SystemUser {
    
    enum UserRole: String, Codable {
        case business = "business"
        case manager = "manager"
        case employee = "employee"
        case accountant = "accountant"
    }
    
}

//
//  Employee.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import FirebaseFirestoreSwift

struct Employee: DomainEntity {
    @DocumentID var uid: String?
    var businessId: String
    var type: EmployeeType
    var fullName: String
    var jobTitle: String
    
    static var collection: String {
        return "employee"
    }
}

extension Employee {
    
    enum EmployeeType: String, CaseIterable, Codable {
        case employee = "Employee"
        case manager = "Manager"
        case accountant = "Accountant"
    }
}

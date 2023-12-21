//
//  ControlSector.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation

enum ControlSector: Int, CaseIterable {
    
    case accountants = 0
    case managers
    case employee
    
    var localizedTitle: String {
        switch self {
        case .accountants:
            return "Accountants"
        case .managers:
            return "Managers"
        case .employee:
            return "Employee"
        }
    }
}

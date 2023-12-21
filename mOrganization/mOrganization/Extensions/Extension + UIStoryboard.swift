//
//  Extension + UIStoryboard.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import UIKit


enum Stroryboard: String {
    case auth = "Auth"
    case business = "Business"
    case employee = "Employee"
    case accountant = "Accountant"
    case manager = "Manager"
}

extension UIStoryboard {
    
    static func instantiateViewController<T>(_ storyboardName: Stroryboard, _ identifier: String) -> T? {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T
        return vc
    }
}

//
//  EmployeeProfileSetting.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import UIKit

enum EmployeeProfileSetting: CaseIterable {
    case changeImage
    case deleteProfile
    
    var localizedTitle: String {
        switch self {
        case .changeImage:
            return "Change profile Image"
        case .deleteProfile:
            return "Delete profile"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .deleteProfile:
            return .red
        default:
            return .label
        }
    }
}

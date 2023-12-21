//
//  BusinessProfileSetting.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import UIKit

enum BusinessProfileSetting: CaseIterable {
    case changeImage
    case changeTitle
    case changeType
    case changeAdress
    case changeFieldOfActivity
    case shareInviteCode
    case deleteBusiness
    
    var localizedTitle: String {
        switch self {
        case .changeImage:
            return "Change organization Image"
        case .changeTitle:
            return "Change organization title"
        case .changeType:
            return "Change organization type"
        case .changeAdress:
            return "Change organization adress"
        case .changeFieldOfActivity:
            return "Change organization field of activity"
        case .shareInviteCode:
            return "Share invite code"
        case .deleteBusiness:
            return "Delete profile"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .deleteBusiness:
            return .red
        default:
            return .label
        }
    }
}

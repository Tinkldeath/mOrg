//
//  FunctionalitySector.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import UIKit

enum FunctionalitySector: Int, CaseIterable {
    case mail = 0
    case documents
    
    var localizedTitle: String {
        switch self {
        case .mail:
            return "Mail"
        case .documents:
            return "Documents"
        }
    }
    
    var associatedImage: UIImage? {
        switch self {
        case .mail:
            return UIImage(systemName: "mail.stack")
        case .documents:
            return UIImage(systemName: "tray.full")
        }
    }
}

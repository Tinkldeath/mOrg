//
//  BusinessSector.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import UIKit

enum BusinessSector: Int, CaseIterable {
    
    case clients = 0
    case products
    case storages
    
    var localizedTitle: String {
        switch self {
        case .clients:
            return "Clients"
        case .products:
            return "Products"
        case .storages:
            return "Storages"
        }
    }
    
    var associatedImage: UIImage? {
        switch self {
        case .clients:
            return UIImage(systemName: "person.3")
        case .products:
            return UIImage(systemName: "cube.box")
        case .storages:
            return UIImage(systemName: "box.truck")
        }
    }
}

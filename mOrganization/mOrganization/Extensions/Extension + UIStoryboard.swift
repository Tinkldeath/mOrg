//
//  Extension + UIStoryboard.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import UIKit


enum Stroryboard: String {
    case main = "Main"
    case auth = "Auth"
}

extension UIStoryboard {
    
    static func getViewController<T>(_ storyboardName: Stroryboard, _ identifier: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Cannot instantiate viewcontroller of identifier \(identifier) at storyboard \(storyboardName.rawValue)")
        }
        return vc
    }
    
}

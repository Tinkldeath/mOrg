//
//  AppCoordinator.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import UIKit


protocol AppCoordinator {
    
    func start()
    
}


final class GlobalCoordinator: AppCoordinator {
    
    private var navigationController = UINavigationController()
    private var window: UIWindow?
    
    private lazy var authCoordinator: AuthCoordinator = {
        let authCoordinator = GeneralAuthCoordinator(navigationController)
        return authCoordinator
    }()
    
    init(_ window: UIWindow?) {
        self.window = window
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        authCoordinator.start()
    }

}
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
    private var managerFactory = DefaultManagerFactory()
    private var window: UIWindow?
    
    private lazy var authCoordinator: AuthCoordinator = {
        let authCoordinator = GeneralAuthCoordinator(navigationController, managerFactory)
        return authCoordinator
    }()
    
    init(_ window: UIWindow?) {
        self.window = window
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        let storageManager = managerFactory.getStorageManager()
        if let _ = storageManager.systemUser {
            authCoordinator.coordinateUserFlow()
        } else {
            authCoordinator.start()
        }
    }

}

//
//  BaseTabBarController.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import UIKit

class BaseTabBarController: UITabBarController {

    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers = self.viewControllers?.compactMap({ $0 as? UINavigationController })
        viewControllers?.forEach({ navController in
            let baseVC = navController.viewControllers.first(where: { $0 is BaseViewController }) as? BaseViewController
            baseVC?.coordinator = self.coordinator
        })
        tabBar.unselectedItemTintColor = UIColor.label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
}

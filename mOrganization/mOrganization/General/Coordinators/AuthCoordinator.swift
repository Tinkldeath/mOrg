//
//  AuthCoordinator.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import UIKit


protocol AuthRoutable {
    var coordinator: AuthCoordinator? { get set }
}


protocol AuthCoordinator {
    func start()
    func coordinateSignIn()
    func coordinateSignUp()
    func coordinatePrivacy()
    func coordinateTermsOfUse()
    func coordinateUserFlow()
}


final class GeneralAuthCoordinator: AuthCoordinator {
    
    private var navigationController: UINavigationController
    
    private var managerFactory: ManagerFactory
    
    init(_ navigationController: UINavigationController, _ managerFactory: ManagerFactory) {
        self.navigationController = navigationController
        self.managerFactory = managerFactory
    }
    
    func start() {
        navigationController.isNavigationBarHidden = true
        let vc: SignInViewController = UIStoryboard.getViewController(.auth, "SignInViewController")
        vc.viewModel = SignInViewModel(managerFactory)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func coordinateSignIn() {
        navigationController.popViewController(animated: true)
    }
    
    func coordinateSignUp() {
        let vc: SignUpViewController = UIStoryboard.getViewController(.auth, "SignUpViewController")
        vc.viewModel = SignUpViewModel(managerFactory)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func coordinatePrivacy() {
        guard let url = Bundle.main.url(forResource: "Privacy", withExtension: "md") else { return }
        let vc: TextViewController = UIStoryboard.getViewController(.auth, "TextViewController")
        let viewModel = TextViewModel("Privacy policy")
        viewModel.loadTextFromUrl(url)
        vc.viewModel = viewModel
        navigationController.present(vc, animated: true)
    }
    
    func coordinateTermsOfUse() {
        guard let url = Bundle.main.url(forResource: "Terms", withExtension: "md") else { return }
        let vc: TextViewController = UIStoryboard.getViewController(.auth, "TextViewController")
        let viewModel = TextViewModel("Terms of use")
        viewModel.loadTextFromUrl(url)
        vc.viewModel = viewModel
        navigationController.present(vc, animated: true)
    }
    
    func coordinateUserFlow() {
        let ciper = AesSecurityManager()
        let storageManager = managerFactory.getStorageManager()
        guard let user = storageManager.systemUser else { return }
        switch user.type {
        case .business:
            let vc: UITabBarController = UIStoryboard.getViewController(.business, "BusinessTabBarController")
            navigationController.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
}

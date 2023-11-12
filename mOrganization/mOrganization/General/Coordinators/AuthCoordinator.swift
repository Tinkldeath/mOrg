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
}


final class GeneralAuthCoordinator: AuthCoordinator {
    
    private var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.isNavigationBarHidden = true
        let vc: SignInViewController = UIStoryboard.getViewController(.auth, "SignInViewController")
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func coordinateSignIn() {
        navigationController.popViewController(animated: true)
    }
    
    func coordinateSignUp() {
        let vc: SignUpViewController = UIStoryboard.getViewController(.auth, "SignUpViewController")
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
    
}

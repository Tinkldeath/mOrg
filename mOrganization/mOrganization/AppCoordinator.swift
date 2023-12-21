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
    func coordinateSignIn()
    func coordinateSignUpAsBusiness()
    func coordinateSignUpAsEmployee()
    func coordinatePrivacy()
    func coordinateTermsOfUse()
    func coordinateUserFlow(for business: Business)
    func coordinateUserFlow(for employee: Employee)
    func coordinateFunctionalitySector(_ sector: FunctionalitySector)
    func coordinateBusinessProfile()
    func back()
}

final class GlobalCoordinator: AppCoordinator {

    private var navigationController: UINavigationController = {
        let nc = UINavigationController()
        nc.isNavigationBarHidden = true
        return nc
    }()
    
    private let authManager: AuthManager = DefaultAuthManager()
    private var managerFactory = DefaultManagerFactory()
    private var window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        coordinateSignIn()
    }

    func coordinateSignIn() {
        guard let vc: SignInViewController = UIStoryboard.instantiateViewController(.auth, "SignInViewController") else { return }
        vc.viewModel = SignInViewModel(managerFactory)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func coordinateSignUpAsBusiness() {
        guard let vc: SignUpBusinessViewController = UIStoryboard.instantiateViewController(.auth, "SignUpBusinessViewController") else { return }
        vc.viewModel = SignUpBusinessViewModel(managerFactory)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func coordinateSignUpAsEmployee() {
        guard let vc: SignUpEmployeeViewController = UIStoryboard.instantiateViewController(.auth, "SignUpEmployeeViewController") else { return }
        vc.viewModel = SignUpEmployeeViewModel(managerFactory)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func coordinatePrivacy() {
        guard let url = Bundle.main.url(forResource: "Privacy", withExtension: "md"), let vc: TextViewController = UIStoryboard.instantiateViewController(.auth, "TextViewController") else { return }
        let viewModel = TextViewModel("Privacy policy")
        viewModel.loadTextFromUrl(url)
        vc.viewModel = viewModel
        navigationController.present(vc, animated: true)
    }
    
    func coordinateTermsOfUse() {
        guard let url = Bundle.main.url(forResource: "Terms", withExtension: "md"), let vc: TextViewController = UIStoryboard.instantiateViewController(.auth, "TextViewController") else { return }
        let viewModel = TextViewModel("Terms of use")
        viewModel.loadTextFromUrl(url)
        vc.viewModel = viewModel
        navigationController.present(vc, animated: true)
    }
    
    func coordinateFunctionalitySector(_ sector: FunctionalitySector) {
        // TODO: - Display screen based on user
    }
    
    func coordinateUserFlow(for business: Business) {
        guard let vc: BaseTabBarController = UIStoryboard.instantiateViewController(.business, "BusinessTabBarController") else { return }
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func coordinateUserFlow(for employee: Employee) {
        switch employee.type {
        case .employee:
            break
        case .accountant:
            break
        case .manager:
            break
        }
    }
    
    func coordinateBusinessProfile() {
        guard let vc: BusinessProfileViewController = UIStoryboard.instantiateViewController(.business, "BusinessProfileViewController") else { return }
        let viewModel = BusinessProfileViewModel(managerFactory)
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}

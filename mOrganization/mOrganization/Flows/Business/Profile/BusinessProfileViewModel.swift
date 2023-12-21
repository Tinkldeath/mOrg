//
//  BusinessProfileViewModel.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import UIKit
import RxRelay

final class BusinessProfileViewModel {
    
    let titleRelay = BehaviorRelay<String>(value: "Profile")
    let adressRelay = BehaviorRelay<String>(value: "Adress")
    let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    let profileSettingsRelay = BehaviorRelay<[BusinessProfileSetting]>(value: BusinessProfileSetting.allCases)
    let inviteCodeRelay = PublishRelay<String>()
    
    private var authManager: AuthManager
    private var businessManager: BusinessManager
    private var business: Business?
    
    init(_ managerFactory: ManagerFactory) {
        self.authManager = managerFactory.authManager
        self.businessManager = managerFactory.businessManager
        initialize()
    }
    
    func didSelectSetting(_ setting: BusinessProfileSetting) {
        switch setting {
        case .shareInviteCode:
            guard let business = business else { return }
            let code = Ciper.unseal(business.inviteCode)
            inviteCodeRelay.accept(code)
        default:
            return
        }
    }
}

private extension BusinessProfileViewModel {
    
    private func initialize() {
        guard let uid = authManager.currentUser else { return }
        businessManager.observeBusiness(uid) { [weak self] business in
            guard let business = business else { return }
            self?.titleRelay.accept(business.title + " \(business.type.abbreviation)")
            self?.adressRelay.accept(business.adress)
            self?.business = business
        }
    }
}

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
    let loadingRelay = PublishRelay<Void>()
    let endLoadingRelay = PublishRelay<Void>()
    
    private var authManager: AuthManager
    private var businessManager: BusinessManager
    let imageManager: ImageManager
    private var business: Business?
    
    init(_ managerFactory: ManagerFactory) {
        self.authManager = managerFactory.authManager
        self.businessManager = managerFactory.businessManager
        self.imageManager = managerFactory.imageManager
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
    
    func changeProfileImage(_ image: UIImage) {
        guard var business = business, let uid = business.uid else { return }
        let imageUrl = "business/" + uid + ".jpg"
        loadingRelay.accept(())
        imageManager.uploadImage(imageUrl, image) { [weak self] imageUrl in
            guard let imageUrl = imageUrl else { self?.endLoadingRelay.accept(()); return }
            business.imageUrl = imageUrl
            self?.businessManager.updateBusiness(business, { completed in
                self?.endLoadingRelay.accept(())
                guard completed else { return }
                self?.imageRelay.accept(image)
            })
        }
    }
    
    func signOut(_ completion: @escaping BoolClosure) {
        loadingRelay.accept(())
        authManager.logout { [weak self] loggedOut in
            self?.endLoadingRelay.accept(())
            completion(loggedOut)
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

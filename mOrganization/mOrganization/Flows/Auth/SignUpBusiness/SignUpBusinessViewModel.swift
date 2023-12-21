//
//  SignUpViewModel.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import RxRelay
import UIKit


final class SignUpBusinessViewModel {
    
    let isValidInput: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let signUpStartEvent: PublishRelay<Void> = PublishRelay()
    
    let signUpEndEvent: PublishRelay<(Business?, String?)> = PublishRelay()
    
    private var lastInput: Input?
    
    private var authManager: AuthManager
    private var businessManager: BusinessManager
    
    init(_ managerFactory: ManagerFactory) {
        self.authManager = managerFactory.authManager
        self.businessManager = managerFactory.businessManager
    }
    
    func enterInput(_ input: Input) {
        isValidInput.accept(input.isValid())
        lastInput = input
    }
    
    func signUp() {
        guard let input = lastInput, input.isValid() else { return }
        signUpStartEvent.accept(())
        authManager.registerUser((email: input.email, password: input.password)) { [weak self] userId in
            guard let userId = userId else { self?.signUpEndEvent.accept((nil, "Maybe user with email already exists")); return }
            let inviteCode = Ciper.seal(String.generateRandomNumberString(16))
            let business = Business(uid: userId, title: input.title, type: input.type, adress: input.adress, fieldOfActivity: input.fieldOfActivity, inviteCode: inviteCode, imageUrl: nil)
            self?.businessManager.updateBusiness(business, { updated in
                guard updated else { self?.signUpEndEvent.accept((nil, "Something went wrong")); return }
                self?.signUpEndEvent.accept((business, "User created"))
            })
        }
    }
    
}

extension SignUpBusinessViewModel {
    
    struct Input {
        var title: String
        var type: Business.BusinessType
        var fieldOfActivity: String
        var adress: String
        var email: String
        var password: String
        
        func isValid() -> Bool {
            return !title.isEmpty && !adress.isEmpty && email.isValidEmail() && password.isValidPassword() && !fieldOfActivity.isEmpty
        }
    }
    
}

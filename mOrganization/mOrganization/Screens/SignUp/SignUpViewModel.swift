//
//  SignUpViewModel.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import RxRelay
import UIKit


final class SignUpViewModel {
    
    private(set) var isValidInput: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private(set) var signUpStartEvent: PublishRelay<Void> = PublishRelay()
    
    private(set) var signUpEndEvent: PublishRelay<(Bool, String?)> = PublishRelay()
    
    private var lastInput: Input?
    
    private var authManager: AuthManager
    
    private var storageManager: StorageManager
    
    init(_ managerFactory: ManagerFactory) {
        self.authManager = managerFactory.getAuthManager()
        self.storageManager = managerFactory.getStorageManager()
    }
    
    func enterInput(_ input: Input) {
        isValidInput.accept(input.isValid())
        lastInput = input
    }
    
    func signUp() {
        guard let input = lastInput else { return }
        signUpStartEvent.accept(())
        authManager.signUpAsBusiness(input) { [weak self] user, message in
            self?.signUpEndEvent.accept((user != nil, message))
            self?.storageManager.storeSystemUser(user)
        }
    }
    
}

extension SignUpViewModel {
    
    struct Input {
        var title: String
        var type: String
        var adress: String
        var email: String
        var password: String
        var image: UIImage?
        
        func isValid() -> Bool {
            return !title.isEmpty && !type.isEmpty && !adress.isEmpty && email.isValidEmail() && password.isValidPassword()
        }
    }
    
}

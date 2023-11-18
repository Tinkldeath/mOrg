//
//  SignInViewModel.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import RxRelay


final class SignInViewModel {
    
    private(set) var isInputValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private(set) var signInStartEvent: PublishRelay<Void> = PublishRelay()
    
    private(set) var signInEndEvent: PublishRelay<(Bool, String?)> = PublishRelay()
    
    private var lastInput: Input?
    
    private var authManager: AuthManager
    
    private var storageManager: StorageManager
    
    init(_ managerFactory: ManagerFactory) {
        self.authManager = managerFactory.getAuthManager()
        self.storageManager = managerFactory.getStorageManager()
    }
    
    func enterInput(_ input: Input) {
        isInputValid.accept(input.isValid())
        lastInput = input
    }
    
    func signIn() {
        guard let input = lastInput else { return }
        signInStartEvent.accept(())
        authManager.signIn(input) { [weak self] user, message in
            self?.signInEndEvent.accept((user != nil, message))
            self?.storageManager.storeSystemUser(user)
        }
    }
    
}

extension SignInViewModel {
    
    struct Input {
        var email: String
        var password: String
        
        func isValid() -> Bool {
            return email.isValidEmail() && !password.isEmpty
        }
    }
    
}

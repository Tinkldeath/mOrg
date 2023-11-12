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
    
    private var lastInput: Input?
    
    func enterInput(_ input: Input) {
        isInputValid.accept(input.isValid())
        lastInput = input
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

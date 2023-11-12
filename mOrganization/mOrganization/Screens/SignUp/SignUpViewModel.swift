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
    
    private var lastInput: Input?
    
    func enterInput(_ input: Input) {
        isValidInput.accept(input.isValid())
        lastInput = input
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

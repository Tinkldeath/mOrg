//
//  SignUpEmployeeViewModel.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import RxRelay

final class SignUpEmployeeViewModel {
    
    let isValidInput = BehaviorRelay<Bool>(value: false)
    
    let signUpStartEvent: PublishRelay<Void> = PublishRelay()
    
    let signUpEndEvent: PublishRelay<(Employee?, String?)> = PublishRelay()
    
    private var businessManager: BusinessManager
    private var authManager: AuthManager
    private var employeeManager: EmployeeManager
    private var input: Input?
    
    init(_ managerFactory: ManagerFactory) {
        self.authManager = managerFactory.authManager
        self.businessManager = managerFactory.businessManager
        self.employeeManager = managerFactory.employeeManager
    }
    
    func enterInput(_ input: Input) {
        isValidInput.accept(input.isValid())
        self.input = input
    }
    
    func signUp() {
        guard let input = input, input.isValid() else { return }
        signUpStartEvent.accept(())
        authManager.registerUser((email: input.email, password: input.password)) { [weak self] userId in
            guard let userId = userId else { self?.signUpEndEvent.accept((nil, "User with this email already exists")); return }
            self?.businessManager.businessId(input.businessInviteCode, { businessId in
                guard let businessId = businessId else { self?.signUpEndEvent.accept((nil, "Business invite code is invalid")); return }
                let user = Employee(uid: userId, businessId: businessId, type: input.type, fullName: input.fullName, jobTitle: input.jobTitle)
                self?.employeeManager.createEmployee(user, { created in
                    guard created else { self?.signUpEndEvent.accept((nil, "Something went wrong")); return }
                    self?.signUpEndEvent.accept((user, "Profile created"))
                })
            })
        }
    }
}

extension SignUpEmployeeViewModel {
    
    struct Input {
        var type: Employee.EmployeeType
        var businessInviteCode: String
        var fullName: String
        var jobTitle: String
        var email: String
        var password: String
        
        func isValid() -> Bool {
            return !fullName.isEmpty && !jobTitle.isEmpty && email.isValidEmail() && password.isValidPassword() && businessInviteCode.count == 16
        }
    }
}

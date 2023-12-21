//
//  SignInViewModel.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import RxRelay


final class SignInViewModel {
    
    let isInputValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let signInStartEvent: PublishRelay<Void> = PublishRelay()
    
    let signInBusinessEvent = PublishRelay<(Business?, String)>()
    
    let signInEmployeeEvent = PublishRelay<(Employee?, String)>()
    
    private var lastInput: Input?
    
    private var authManager: AuthManager
    private var businessManager: BusinessManager
    private var employeeManager: EmployeeManager
    
    init(_ managerFactory: ManagerFactory) {
        self.authManager = managerFactory.authManager
        self.businessManager = managerFactory.businessManager
        self.employeeManager = managerFactory.employeeManager
    }
    
    func enterInput(_ input: Input) {
        isInputValid.accept(input.isValid())
        lastInput = input
    }
    
    func signInAsBusiness() {
        guard let input = lastInput else { return }
        signInStartEvent.accept(())
        authManager.signIn((email: input.email, password: input.password)) { [weak self] businessId in
            guard let businessId = businessId else { self?.signInBusinessEvent.accept((nil, "Incorrect email or password")); return };
            self?.businessManager.observeBusiness(businessId, { business in
                guard let business = business else { self?.signInBusinessEvent.accept((nil, "User does not registered as business, try sign in as employee")); return }
                self?.signInBusinessEvent.accept((business, "Signed in"))
            })
        }
    }
    
    func signInAsEmployee() {
        guard let input = lastInput else { return }
        signInStartEvent.accept(())
        authManager.signIn((email: input.email, password: input.password)) { [weak self] employeeId in
            guard let employeeId = employeeId else { self?.signInEmployeeEvent.accept((nil, "Incorrect email or password")); return };
            self?.employeeManager.observeEmployee(employeeId, { employee in
                guard let employee = employee else { self?.signInEmployeeEvent.accept((nil, "User does not registered as business, try sign in as employee")); return }
                self?.signInEmployeeEvent.accept((employee, "Signed in"))
            })
        }
    }
}

extension SignInViewModel {
    
    struct Input {
        var email: String
        var password: String
        
        func isValid() -> Bool {
            return email.isValidEmail() && password.isValidPassword()
        }
    }
    
}

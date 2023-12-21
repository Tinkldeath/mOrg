//
//  EmployeeProfileViewModel.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import RxRelay
import UIKit

final class EmployeeProfileViewModel {
    
    let settingsRelay = BehaviorRelay<[EmployeeProfileSetting]>(value: EmployeeProfileSetting.allCases)
    let employeeRelay = BehaviorRelay<Employee?>(value: nil)
    let loadingRelay = PublishRelay<Void>()
    let endLoadingRelay = PublishRelay<Void>()
    
    private let authManager: AuthManager
    let imageManager: ImageManager
    private let employeeManager: EmployeeManager
    
    init(_ managerFactory: ManagerFactory) {
        self.authManager = managerFactory.authManager
        self.imageManager = managerFactory.imageManager
        self.employeeManager = managerFactory.employeeManager
        initialize()
    }
    
    func changeProfileImage(_ image: UIImage, _ completion: @escaping ImageClosure) {
        guard let uid = employeeManager.currentEmployee, var employee = employeeRelay.value else { return }
        let imageUrl = "employee/" + uid + ".jpg"
        loadingRelay.accept(())
        imageManager.uploadImage(imageUrl, image) { [weak self] imageUrl in
            guard let imageUrl = imageUrl else { self?.endLoadingRelay.accept(()); completion(nil); return }
            employee.imageUrl = imageUrl
            self?.employeeManager.updateEmployee(employee, { updated in
                self?.endLoadingRelay.accept(())
                guard updated else { completion(nil); return }
                completion(image)
            })
        }
    }
    
    func deleteProfile() {
        
    }
    
    func signOut(_ completion: @escaping BoolClosure) {
        authManager.logout { loggedOut in
            completion(loggedOut)
        }
    }
}

private extension EmployeeProfileViewModel {
    
    private func initialize() {
        guard let uid = employeeManager.currentEmployee else { return }
        employeeManager.observeEmployee(uid) { [weak self] employee in
            guard let employee = employee else { return }
            self?.employeeRelay.accept(employee)
        }
    }
}

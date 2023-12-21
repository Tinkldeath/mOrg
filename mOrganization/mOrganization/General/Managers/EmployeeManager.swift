//
//  EmployeeManager.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation

protocol EmployeeManager: AnyObject {
    var currentEmployee: String? { get set }
    func observeEmployee(for businessId: String, _ observer: @escaping ([Employee]) -> Void)
    func observeEmployee(_ uid: String, _ observer: @escaping (Employee?) -> Void)
    func createEmployee(_ employee: Employee, _ completion: @escaping BoolClosure)
    func updateEmployee(_ employee: Employee, _ completion: @escaping BoolClosure)
    func deleteEmployee(_ employee: Employee, _ completion: @escaping BoolClosure)
}

final class DefaultEmployeeManager: EmployeeManager {
    
    var currentEmployee: String?
    
    private var datastore: BaseDataStore
    
    init(_ datastore: BaseDataStore) {
        self.datastore = datastore
    }
    
    func observeEmployee(for businessId: String, _ observer: @escaping ([Employee]) -> Void) {
        datastore.observeBusinessCollection(of: Employee.self, businessId) { employee in
            observer(employee)
        }
    }
    
    func observeEmployee(_ uid: String, _ observer: @escaping (Employee?) -> Void) {
        datastore.observeObject(of: Employee.self, uid) { employee in
            observer(employee)
        }
    }
    
    func createEmployee(_ employee: Employee, _ completion: @escaping BoolClosure) {
        datastore.update(employee) { updated in
            completion(updated)
        }
    }
    
    func updateEmployee(_ employee: Employee, _ completion: @escaping BoolClosure) {
        datastore.update(employee) { updated in
            completion(updated)
        }
    }
    
    func deleteEmployee(_ employee: Employee, _ completion: @escaping BoolClosure) {
        datastore.delete(employee) { deleted in
            completion(deleted)
        }
    }
}

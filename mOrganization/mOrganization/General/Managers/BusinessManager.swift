//
//  BusinessManager.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import FirebaseFirestoreSwift

protocol BusinessManager {
    func businessId(_ businessCode: String, _ completion: @escaping StringClosure)
    func observeBusiness(_ businessId: String, _ completion: @escaping (Business?) -> Void)
    func createBusiness(_ business: Business, _ completion: @escaping StringClosure)
    func updateBusiness(_ business: Business, _ completion: @escaping BoolClosure)
    func deleteBusiness(_ business: Business, _ completion: @escaping BoolClosure)
}

final class DefaultBusinessManager: BusinessManager {
    
    private var datastore: BaseDataStore
    
    init(_ datastore: BaseDataStore) {
        self.datastore = datastore
    }
    
    func businessId(_ businessCode: String, _ completion: @escaping StringClosure) {
        datastore.observeCollection(of: Business.self) { businesses in
            completion(businesses.first(where: { Ciper.unseal($0.inviteCode) == businessCode })?.uid)
        }
    }
    
    func observeBusiness(_ businessId: String, _ completion: @escaping (Business?) -> Void) {
        datastore.observeObject(of: Business.self, businessId) { business in
            completion(business)
        }
    }
    
    func createBusiness(_ business: Business, _ completion: @escaping StringClosure) {
        datastore.create(business) { businessId in
            completion(businessId)
        }
    }
    
    func updateBusiness(_ business: Business, _ completion: @escaping BoolClosure) {
        datastore.update(business) { updated in
            completion(updated)
        }
    }
    
    func deleteBusiness(_ business: Business, _ completion: @escaping BoolClosure) {
        datastore.delete(business) { deleted in
            completion(deleted)
        }
    }
}

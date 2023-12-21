//
//  BaseDatastore.swift
//  mOrganization
//
//  Created by Dima on 20.12.23.
//

import Foundation

typealias BoolClosure = (Bool) -> Void
typealias StringClosure = (String?) -> Void

protocol BaseDataStore {
    func observeObject<T: DomainEntity>(of type: T.Type, _ uid: String, _ observer: @escaping (T?) -> Void)
    func observeCollection<T: DomainEntity>(of type: T.Type, _ observer: @escaping ([T]) -> Void)
    func observeBusinessCollection<T: DomainEntity>(of type: T.Type, _ businessId: String, _ observer: @escaping ([T]) -> Void)
    func create<T: DomainEntity>(_ entity: T, _ completion: StringClosure?)
    func update<T: DomainEntity>(_ entity: T, _ completion: BoolClosure?)
    func delete<T: DomainEntity>(_ entity: T, _ completion: BoolClosure?)
}

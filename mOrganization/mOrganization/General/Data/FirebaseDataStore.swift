//
//  FirebaseDataStore.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseDataStore: BaseDataStore {
    
    private let firestore = Firestore.firestore()
    
    private var listeners: [ListenerRegistration] = []
    
    static let shared = FirebaseDataStore()
    
    private init() {}
    
    deinit {
        listeners.forEach({ $0.remove() })
    }
    
    func observeObject<T>(of type: T.Type, _ uid: String, _ observer: @escaping (T?) -> Void) where T : DomainEntity {
        let listener = firestore.collection(T.collection).document(uid).addSnapshotListener { snapshot, error in
            guard let entity = try? snapshot?.data(as: T.self), error == nil else { observer(nil); return }
            observer(entity)
        }
        listeners.append(listener)
    }
    
    func observeCollection<T>(of type: T.Type, _ observer: @escaping ([T]) -> Void) where T : DomainEntity {
        let listener = firestore.collection(T.collection).addSnapshotListener { snapshot, error in
            guard let entities = snapshot?.documents.compactMap({ try? $0.data(as: T.self) }), error == nil else { observer([]); return }
            observer(entities)
        }
        listeners.append(listener)
    }
    
    func observeCollection<T>(of type: T.Type, with field: String, isEqual toField: String, _ observer: @escaping ([T]) -> Void) where T : DomainEntity {
        let listener = firestore.collection(T.collection).whereField(field, isEqualTo: toField).addSnapshotListener { snapshot, error in
            guard let entities = snapshot?.documents.compactMap({ try? $0.data(as: T.self) }), error == nil else { observer([]); return }
            observer(entities)
        }
        listeners.append(listener)
    }
    
    func observeBusinessCollection<T>(of type: T.Type, _ businessId: String, _ observer: @escaping ([T]) -> Void) where T : DomainEntity {
        let listener = firestore.collection(T.collection).whereField("businessId", isEqualTo: businessId).addSnapshotListener { snapshot, error in
            guard let entities = snapshot?.documents.compactMap({ try? $0.data(as: T.self) }), error == nil else { observer([]); return }
            observer(entities)
        }
        listeners.append(listener)
    }
    
    func create<T>(_ entity: T, _ completion: StringClosure?) where T : DomainEntity {
        do {
            let document = firestore.collection(T.collection).document()
            var copy = entity
            copy.uid = document.documentID
            try document.setData(from: entity) { error in
                completion?(copy.uid)
            }
        } catch {
            print(String(describing: error))
            completion?(nil)
        }
    }
    
    func update<T>(_ entity: T, _ completion: BoolClosure?) where T : DomainEntity {
        do {
            guard let uid = entity.uid else { completion?(false); return }
            try firestore.collection(T.collection).document(uid).setData(from: entity) { error in
                completion?(error == nil)
            }
        } catch {
            print(String(describing: error))
            completion?(false)
        }
    }
    
    func delete<T>(_ entity: T, _ completion: BoolClosure?) where T : DomainEntity {
        guard let uid = entity.uid else { completion?(false); return }
        firestore.collection(T.collection).document(uid).delete { error in
            completion?(error == nil)
        }
    }
    
}

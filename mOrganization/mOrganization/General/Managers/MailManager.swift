//
//  MailManager.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation

protocol MailManager {
    func observeMail(for userId: String, _ observer: @escaping ([Mail]) -> Void)
    func observeMail(_ uid: String, _ observer: @escaping (Mail?) -> Void)
    func createMail(_ mail: Mail, _ completion: @escaping BoolClosure)
    func deleteMail(_ mail: Mail, _ completion: @escaping BoolClosure)
}

final class DefaultMailManager: MailManager {

    private var datastore: BaseDataStore
    
    init(_ datastore: BaseDataStore) {
        self.datastore = datastore
    }
    
    func observeMail(for userId: String, _ observer: @escaping ([Mail]) -> Void) {
        datastore.observeCollection(of: Mail.self, with: "reciever", isEqual: userId) { mail in
            observer(mail)
        }
    }
    
    func observeMail(_ uid: String, _ observer: @escaping (Mail?) -> Void) {
        datastore.observeObject(of: Mail.self, uid) { mail in
            observer(mail)
        }
    }
    
    func createMail(_ mail: Mail, _ completion: @escaping BoolClosure) {
        datastore.create(mail) { mailId in
            completion(mailId != nil)
        }
    }
    
    func deleteMail(_ mail: Mail, _ completion: @escaping BoolClosure) {
        datastore.delete(mail) { deleted in
            completion(deleted)
        }
    }
}

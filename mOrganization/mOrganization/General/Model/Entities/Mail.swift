//
//  Mail.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import FirebaseFirestoreSwift

struct Mail: DomainEntity {
    @DocumentID var uid: String?
    var sender: String
    var reciever: String
    var header: Data
    var theme: Data
    var content: Data
    var attachments: [String]
    
    static var collection: String {
        return "mail"
    }
}

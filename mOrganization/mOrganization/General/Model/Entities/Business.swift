//
//  Business.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import FirebaseFirestoreSwift

struct Business: DomainEntity {
    @DocumentID var uid: String?
    var title: String
    var type: BusinessType
    var adress: String
    var fieldOfActivity: String
    var inviteCode: Data
    var imageUrl: String?
    
    static var collection: String {
        return "business"
    }
}

extension Business {
    enum BusinessType: String, Codable, CaseIterable {
        case llc = "Limited Liability Company" // OOO
        case prjsc = "Private Joint-Stock Company" // ЗАО
        case pjsc = "Public Joint-Stock Company" // ОАО
        case ie = "Individual Entrepreneur" // ИП
        case ue = "Unitary Enterprise" // УП
        
        var abbreviation: String {
            switch self {
            case .llc:
                return "LLC"
            case .prjsc:
                return "PRJSC"
            case .pjsc:
                return "PJSC"
            case .ie:
                return "IE"
            case .ue:
                return "UE"
            }
        }
    }
}

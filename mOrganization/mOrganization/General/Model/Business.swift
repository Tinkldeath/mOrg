//
//  Business.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation


struct Business {
    
    var uid: String
    var ownerId: String
    var title: String
    var type: BusinessType
    var adress: String
    var mail: String
    var imageUrl: String?
    var managers: [String]
    var accountants: [String]
    var employee: [String]
    var projects: [String]
    var documents: [String]
    var products: [String]
    var storages: [String]
    var clients: [String]
    var deals: [String]
    
    init(_ title: String, _ businessType: BusinessType, _ adress: String, _ imageUrl: String?) {
        self.uid = ""
        self.ownerId = ""
        self.title = title
        self.type = businessType
        self.adress = adress
        self.mail = "\(title.lowercased().replacingOccurrences(of: " ", with: "_")).\(type.abbreviation)@mrta.org"
        self.imageUrl = imageUrl
        self.managers = []
        self.accountants = []
        self.employee = []
        self.projects = []
        self.documents = []
        self.products = []
        self.storages = []
        self.clients = []
        self.deals = []
    }
    
}

extension Business {
    enum BusinessType: String, CaseIterable, Codable {
        case IE = "IE" // Individual entrepreneur"
        case UE = "UE" //"Unitary enterprise"
        case LLC = "LLC" //"Limited liability company"
        case ALC = "ALC" //"Ddditional liability company"
        case OJSC = "OJSC" // "Opened joint-stock company"
        case CJSC = "CJSC" // "Closed joint-stock company"
        
        var abbreviation: String {
            return self.rawValue.lowercased()
        }
        
        var full: String {
            switch self {
            case .IE:
                return "Individual entrepreneur"
            case .UE:
                return "Unitary enterprise"
            case .ALC:
                return "Limited liability company"
            case .LLC:
                return "Ddditional liability company"
            case .OJSC:
                return "Opened joint-stock company"
            case .CJSC:
                return "Closed joint-stock company"
            }
        }
    }
}

extension Business: FirebaseEntity {
    
    init?(_ from: [String : Any]) {
        guard let uid = from["uid"] as? String else { return nil }
        guard let ownerId = from["ownerId"] as? String else { return nil }
        guard let title = from["title"] as? String else { return nil }
        guard let type = from["type"] as? String else { return nil }
        guard let finalType = BusinessType(rawValue: type) else { return nil }
        guard let adress = from["adress"] as? String else { return nil }
        guard let imageUrl = from["imageUrl"] as? String? else { return nil }
        guard let mail = from["mail"] as? String else { return nil }
        guard let managers = from["managers"] as? [String] else { return nil }
        guard let accountants = from["accountants"] as? [String] else { return nil }
        guard let employee = from["employee"] as? [String] else { return nil }
        guard let projects = from["projects"] as? [String] else { return nil }
        guard let documents = from["documents"] as? [String] else { return nil }
        guard let products = from["products"] as? [String] else { return nil }
        guard let storages = from["storages"] as? [String] else { return nil }
        guard let clients = from["clients"] as? [String] else { return nil }
        guard let deals = from["deals"] as? [String] else { return nil }
        self.uid = uid
        self.ownerId = ownerId
        self.title = title
        self.type = finalType
        self.adress = adress
        self.mail = mail
        self.imageUrl = imageUrl
        self.managers = managers
        self.accountants = accountants
        self.employee = employee
        self.projects = projects
        self.documents = documents
        self.products = products
        self.storages = storages
        self.clients = clients
        self.deals = deals
    }
    
    func toEntity() -> [String : Any] {
        return [
            "uid": self.uid,
            "ownerId": self.ownerId,
            "title": self.title,
            "type": self.type.rawValue,
            "adress": self.adress,
            "mail": self.mail,
            "imageUrl": self.imageUrl as Any,
            "managers": self.managers,
            "accountants": self.accountants,
            "employee": self.employee,
            "projects": self.projects,
            "documents": self.documents,
            "products": self.products,
            "storages": self.storages,
            "clients": self.clients,
            "deals": self.deals
        ]
    }
    
    static func collection() -> String {
        return "business"
    }
    
}

//
//  FirebaseEntity.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import FirebaseFirestoreSwift

protocol DomainEntity: Hashable, Codable, Equatable {
    var uid: String? { get set }
    static var collection: String { get }
}

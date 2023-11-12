//
//  FirebaseEntity.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation


protocol FirebaseEntity: Codable {
    init?(_ from: [String: Any])
    func toEntity() -> [String: Any]
    static func collection() -> String
}

//
//  SecurityManager.swift
//  mOrganization
//
//  Created by Dima on 18.11.23.
//

import Foundation
import CryptoKit


protocol SecurityManager {
    func seal(_ string: String) -> Data
    func unseal(_ data: Data) -> String
}


final class AesSecurityManager: SecurityManager {
    
    private var masterKey: SymmetricKey = {
        let keyData: Data = Data([181, 23, 62, 5, 113, 182, 95, 110, 66, 160, 107, 41, 221, 29, 201, 206, 125, 98, 71, 210, 135, 8, 143, 160, 17, 30, 150, 61, 105, 114, 146, 72])
        return SymmetricKey(data: keyData)
    }()
    
    func seal(_ string: String) -> Data {
        guard let data = string.data(using: .utf8) else { fatalError("Cannot get UTF8 data for \(string)") }
        guard let sealedBox = try? AES.GCM.seal(data, using: masterKey) else { fatalError("Cannot encrypt data for \(masterKey)") }
        guard let encData = sealedBox.combined else { fatalError("Cannot get data from \(sealedBox)") }
        return encData
    }
    
    func unseal(_ data: Data) -> String {
        guard let sealedBox = try? AES.GCM.SealedBox(combined: data) else { fatalError("Cannot get sealed box for \(data)") }
        guard let decData = try? AES.GCM.open(sealedBox, using: masterKey) else { fatalError("Cannot open sealed box \(sealedBox)") }
        guard let string = String(data: decData, encoding: .utf8) else { fatalError("Cannot convert to UTF8 string from \(decData)") }
        return string
    }

}

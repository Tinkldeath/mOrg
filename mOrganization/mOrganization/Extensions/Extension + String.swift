//
//  Extension + String.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // Пароль должен содержать как минимум 8 символов, включая цифры и буквы
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }
    
    static func generateRandomNumberString(_ length: Int) -> String {
        var result = ""
        for _ in 0..<length {
            result += "\(Int.random(in: 0..<10))"
        }
        return result
    }
}

extension String? {
    
    func orEmpty() -> String {
        return self ?? ""
    }
}

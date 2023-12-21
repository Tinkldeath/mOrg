//
//  AuthManager.swift
//  mOrganization
//
//  Created by Dima on 18.11.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol AuthManager {
    typealias Input = (email: String, password: String)
    
    var currentUser: String? { get }
    
    func registerUser(_ input: Input, _ completion: @escaping StringClosure)
    func signIn(_ input: Input, _ completion: @escaping StringClosure)
    func logout(_ completion: @escaping BoolClosure)
}

final class DefaultAuthManager: AuthManager {
    
    private let auth = Auth.auth()
    
    var currentUser: String? {
        return auth.currentUser?.uid
    }
    
    init() {
        auth.signInAnonymously()
    }
    
    func registerUser(_ input: Input, _ completion: @escaping StringClosure) {
        guard input.email.isValidEmail(), input.password.isValidPassword() else { completion(nil); return }
        auth.createUser(withEmail: input.email, password: input.password) { result, error in
            completion(result?.user.uid)
        }
    }
    
    func signIn(_ input: Input, _ completion: @escaping StringClosure) {
        guard input.email.isValidEmail(), input.password.isValidPassword() else { completion(nil); return }
        auth.signIn(withEmail: input.email, password: input.password) { result, error in
            completion(result?.user.uid)
        }
    }
    
    func logout(_ completion: @escaping BoolClosure) {
        do {
            try auth.signOut()
            auth.signInAnonymously { result, error in
                completion(error == nil)
            }
        } catch {
            completion(false)
        }
    }
}

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


typealias AuthCompletionHandler = (_ user: SystemUser?, _ message: String?) -> ()


protocol AuthManager {
    func signIn(_ input: SignInViewModel.Input, _ completion: @escaping AuthCompletionHandler)
    func signUpAsBusiness(_ input: SignUpViewModel.Input, _ completion: @escaping AuthCompletionHandler)
}


final class DefaultAuthManager: AuthManager {
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func signIn(_ input: SignInViewModel.Input, _ completion: @escaping AuthCompletionHandler) {
        auth.signIn(withEmail: input.email, password: input.password) { [weak self] result, error in
            guard let uid = result?.user.uid else {
                completion(nil, "User does not exist")
                return
            }
            guard error == nil else {
                completion(nil, error!.localizedDescription)
                return
            }
            self?.detectUserRole(uid, { role in
                let user = SystemUser(uid: uid, type: role)
                completion(user, "Suceessfully signed in! Welcome back to mrta.org system!")
            })
        }
    }
    
    func signUpAsBusiness(_ input: SignUpViewModel.Input, _ completion: @escaping AuthCompletionHandler) {
        auth.createUser(withEmail: input.email, password: input.password) { [weak self] result, error in
            guard let uid = result?.user.uid else {
                completion(nil, "User already exists")
                return
            }
            guard error == nil else {
                completion(nil, error!.localizedDescription)
                return
            }
            self?.saveBusiness(uid, input, { complete in
                guard complete == true else { completion(nil, "Something went wrong"); return }
                let user = SystemUser(uid: uid, type: .business)
                completion(user, "Suceessfully signed up! Welcome to mrta.org system!")
            })
        }
    }
    
    private func detectUserRole(_ uid: String, _ completion: @escaping (_ role: SystemUser.UserRole) -> Void) {
        firestore.collection(Business.collection()).whereField("ownerId", isEqualTo: uid).getDocuments { snapshot, error in
            guard let _ = snapshot else { return }
            completion(.business)
        }
    }
    
    private func saveBusiness(_ ownerId: String, _ input: SignUpViewModel.Input, _ completion: @escaping (_ complete: Bool) -> Void) {
        guard let type = Business.BusinessType(rawValue: input.type) else { completion(false); return }
        let doc = firestore.collection(Business.collection()).document()
        if let image = input.image {
            saveBusinessImage(doc.documentID, image) { reference in
                var business = Business(input.title, type, input.adress, reference)
                business.uid = doc.documentID
                business.ownerId = ownerId
                doc.setData(business.toEntity()) { error in
                    completion(error == nil)
                }
            }
        } else {
            var business = Business(input.title, type, input.adress, nil)
            business.uid = doc.documentID
            business.ownerId = ownerId
            doc.setData(business.toEntity()) { error in
                completion(error == nil)
            }
        }
    }

    private func saveBusinessImage(_ businessId: String, _ image: UIImage, _ completion: @escaping (_ reference: String?) -> Void) {
        guard let pngData = image.jpegData(compressionQuality: 0.5) else { completion(nil); return }
        let reference = "images/\(businessId).jpg"
        storage.child(reference).putData(pngData) { metadata, error in
            guard error == nil else {
                print(String(describing: error))
                completion(nil)
                return
            }
            completion(reference)
        }
    }
}

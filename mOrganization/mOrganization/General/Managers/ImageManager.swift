//
//  ImageManager.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import UIKit
import FirebaseStorage

typealias ImageClosure = (UIImage?) -> Void

protocol ImageManager: AnyObject {
    func uploadImage(_ url: String, _ image: UIImage, _ completion: @escaping StringClosure)
    func fetchImage(_ url: String, _ completion: @escaping ImageClosure)
}

final class DefaultImageManager: ImageManager {
    
    private let storage = Storage.storage().reference()
    
    func uploadImage(_ url: String, _ image: UIImage, _ completion: @escaping StringClosure) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { completion(nil); return }
        storage.child(url).putData(data) { metadata, error in
            guard metadata != nil, error == nil else { completion(nil); return }
            completion(url)
        }
    }
    
    func fetchImage(_ url: String, _ completion: @escaping ImageClosure) {
        storage.child(url).getData(maxSize: Int64.max) { data, error in
            guard let data = data, let image = UIImage(data: data) else { completion(nil); return }
            completion(image)
        }
    }

}

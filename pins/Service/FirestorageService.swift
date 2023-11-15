//
//  FireStoreService.swift
//  pins
//
//  Created by 주동석 on 2023/11/10.
//

import UIKit
import OSLog
import FirebaseAuth
import FirebaseStorage

enum FirestorageService {
    private static func metaData(for image: UIImage) -> StorageMetadata {
        let metaData = StorageMetadata()
        metaData.contentType = mimeType(for: image)
        return metaData
    }

    private static func mimeType(for image: UIImage) -> String {
        if let _ = image.pngData() {
            return "image/png"
        } else if let _ = image.jpegData(compressionQuality: 1.0) {
            return "image/jpeg"
        } else {
            return "application/octet-stream"
        }
    }
    
    static func uploadImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let metaData = self.metaData(for: image)

        let firebaseReference = Storage.storage().reference().child("image/\(Auth.auth().currentUser?.uid ?? "")/\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    static func uploadImages(images: [UIImage], completion: @escaping ([URL?]) -> Void) {
        var urls: [URL?] = []
        let dispatchGroup = DispatchGroup()

        for image in images {
            dispatchGroup.enter()
            uploadImage(image: image) { url in
                urls.append(url)
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(urls)
        }
    }
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}

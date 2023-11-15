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
    
    static func uploadImage(image: UIImage) async -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return nil }
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let metaData = self.metaData(for: image)

        let firebaseReference = Storage.storage().reference().child("image/\(Auth.auth().currentUser?.uid ?? "")/\(imageName)")
        
        do {
            let _ = try await firebaseReference.putDataAsync(imageData, metadata: metaData)
            return try await firebaseReference.downloadURL()
        } catch {
            os_log("Error uploading image: \(error)")
            return nil
        }
    }
    
    static func uploadImages(images: [UIImage]) async -> [URL?] {
        var urls: [URL?] = []

        await withTaskGroup(of: URL?.self) { group in
            for image in images {
                group.addTask {
                    return await uploadImage(image: image)
                }
            }
            for await url in group {
                urls.append(url)
            }
        }
        return urls
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

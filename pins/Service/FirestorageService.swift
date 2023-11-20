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

typealias UrlWithIndex = (index: Int, url: URL)

enum FirestorageService {
    private static func metaData(for imageInfo: ImageInfo) -> StorageMetadata {
        let metaData = StorageMetadata()
        metaData.contentType = imageInfo.extensionType
        return metaData
    }
    
    static func uploadImage(imageInfo: ImageInfo) async -> UrlWithIndex {
        guard let imageData = imageInfo.image.jpegData(compressionQuality: 0.6) else { 
            fatalError("Image data is nil")
        }
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let metaData = self.metaData(for: imageInfo)

        let firebaseReference = Storage.storage().reference().child("image/\(Auth.auth().currentUser?.uid ?? "")/\(imageName)")
        
        do {
            let _ = try await firebaseReference.putDataAsync(imageData, metadata: metaData)
            return try await (imageInfo.index, firebaseReference.downloadURL())
        } catch {
            os_log("Error uploading image: \(error)")
            fatalError("Error uploading image: \(error)")
        }
    }
    
    static func uploadImages(imageInfos: [ImageInfo]) async -> [UrlWithIndex] {
        var urls: [UrlWithIndex] = []

        await withTaskGroup(of: UrlWithIndex.self) { group in
            for image in imageInfos {
                group.addTask {
                    return await uploadImage(imageInfo: image)
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

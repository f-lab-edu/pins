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

typealias URLWithIndex = (index: Int, url: URL)

protocol FirestorageServiceProtocol {
    func uploadImage(imageInfo: ImageInfo) async -> URLWithIndex
    func uploadImages(imageInfos: [ImageInfo]) async -> [URLWithIndex]
    func downloadImage(urlString: String) async -> UIImage?
    func createPin(pin: Pin, images: [ImageInfo]) async
    func getPins() async -> [Pin]
}

final class FirestorageService: FirestorageServiceProtocol {
    private var firebaseRepository: FirebaseRepositoryProtocol
    
    init(firebaseRepository: FirebaseRepositoryProtocol) {
        self.firebaseRepository = firebaseRepository
    }
    
    private func metaData(for imageInfo: ImageInfo) -> StorageMetadata {
        let metaData = StorageMetadata()
        metaData.contentType = imageInfo.extensionType
        return metaData
    }
    
    func uploadImage(imageInfo: ImageInfo) async -> URLWithIndex {
        let metaData = self.metaData(for: imageInfo)
        guard let imageData = imageInfo.image.jpegData(compressionQuality: 0.6) else {
            fatalError("Image data is nil")
        }
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let url = await firebaseRepository.uploadImage(imageData: imageData, imageName: imageName, metaData: metaData)
        return (imageInfo.index, url)
    }
    
    func uploadImages(imageInfos: [ImageInfo]) async -> [URLWithIndex] {
        var urls: [URLWithIndex] = []
        for imageInfo in imageInfos {
            let url = await uploadImage(imageInfo: imageInfo)
            urls.append(url)
        }
        return urls
    }
    
    func downloadImage(urlString: String) async -> UIImage? {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        return await withCheckedContinuation { continuation in
            storageReference.getData(maxSize: megaByte) { data, error in
                if let error = error {
                    os_log("Error downloading image: \(error)")
                    continuation.resume(returning: nil)
                } else if let data = data, let image = UIImage(data: data) {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func createPin(pin: Pin, images: [ImageInfo]) async {
        let urls = await uploadImages(imageInfos: images)
        let urlsString = urls.map { $0.url.absoluteString }
        let pin = pin.withUrls(urls: urlsString)
        await firebaseRepository.createPin(pin: pin.toDictionary())
    }
    
    func getPins() async -> [Pin] {
        let result = await firebaseRepository.getPins()
        switch result {
        case .success(let pins):
            return pins.map { Pin.toData($0) }
        case .failure(let error):
            os_log("Error getting pins: %@", error.localizedDescription)
            return []
        }
    }
}

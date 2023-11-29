//
//  PinRepository.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import OSLog
import Firebase
import FirebaseStorage
import FirebaseFirestore

protocol FirebaseRepositoryProtocol {
    func uploadImage(imageData: Data, imageName: String, metaData: StorageMetadata) async -> URL
    func createPin(pin: [String: Any]) async
}

final class FirebaseRepository: FirebaseRepositoryProtocol {
    func uploadImage(imageData: Data, imageName: String, metaData: StorageMetadata) async -> URL {
        let firebaseReference = Storage.storage().reference().child("image/\(Auth.auth().currentUser?.uid ?? "")/\(imageName)")
        
        return await withCheckedContinuation { continuation in
            firebaseReference.putData(imageData, metadata: metaData) { _, error in
                if let error = error {
                    os_log(.error, log: .default, "Error uploading image: %@", error.localizedDescription)
                    fatalError("Error uploading image: \(error.localizedDescription)")
                }
                
                firebaseReference.downloadURL { url, error in
                    if let error = error {
                        os_log(.error, log: .default, "Error downloading image: %@", error.localizedDescription)
                        fatalError("Error downloading image: \(error.localizedDescription)")
                    }
                    guard let url = url else {
                        os_log(.error, log: .default, "Error downloading image: URL is nil")
                        fatalError("Error downloading image: URL is nil")
                    }
                    
                    continuation.resume(returning: url)
                }
            }
        }
    }
    
    func createPin(pin: [String: Any]) async {
        let documentReference = FirebaseFirestore.shared.db.collection("pins").document()
        await withCheckedContinuation { continuation in
            documentReference.setData(pin)
            continuation.resume()
        }
    }
}

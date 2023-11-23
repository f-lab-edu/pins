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
    func getPins() async -> Result<[[String: Any]], Error>
}

final class FirebaseRepository: FirebaseRepositoryProtocol {
    func getPins() async -> Result<[[String: Any]], Error>{
        let db = FirebaseFirestore.shared.db
        let pinsRef = db.collection("pins")
        do {
            let result = try await pinsRef.getDocuments()
            var pins = [[String: Any]]()
            for document in result.documents {
                pins.append(document.data())
            }
            return .success(pins)
        } catch {
            os_log(.error, log: .default, "Error getting documents: %@", error.localizedDescription)
            return .failure(error)
        }
    }
    
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

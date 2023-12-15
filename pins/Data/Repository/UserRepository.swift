//
//  UserRepository.swift
//  pins
//
//  Created by 주동석 on 12/3/23.
//

import OSLog
import Foundation
import FirebaseAuth

protocol UserRepositoryProtocol {
    func getUser(id: String) async -> [String: Any]
    func putUser(user: [String: Any])
}

final class UserRepository: UserRepositoryProtocol {
    func getUser(id: String) async -> [String: Any] {
        let db = FirebaseFirestore.shared.db
        let userRef = db.collection("user")
        do {
            let result = try await userRef.whereField("id", isEqualTo: id).getDocuments()
            var user = [String: Any]()
            for document in result.documents {
                user = document.data()
            }
            return user
        } catch {
            os_log(.error, log: .default, "Error getting documents: %@", error.localizedDescription)
            fatalError("Error getting documents: \(error.localizedDescription)")
        }
    }
    
    func putUser(user: [String: Any]) {
        let db = FirebaseFirestore.shared.db
        let userRef = db.collection("user")
        userRef.addDocument(data: user)
    }
}

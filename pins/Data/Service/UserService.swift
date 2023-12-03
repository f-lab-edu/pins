//
//  UserService.swift
//  pins
//
//  Created by 주동석 on 12/3/23.
//

import Foundation
import OSLog

protocol UserServiceProtocol {
    func getUser(id: String) async -> User?
    func putUser(user: User)
}

final class UserService: UserServiceProtocol {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func getUser(id: String) async -> User? {
        let userData = await userRepository.getUser(id: id)
        let decoder = JSONDecoder()
        do {
            let user = try decoder.decode(User.self, from: JSONSerialization.data(withJSONObject: userData))
            return user
        } catch {
            os_log(.error, log: .default, "Error decoding user: %@", error.localizedDescription)
            return nil
        }
    }
    
    func putUser(user: User) {
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(user)
            let userDict = try JSONSerialization.jsonObject(with: userData) as? [String: Any]
            userRepository.putUser(user: userDict!)
        } catch {
            fatalError("Error putting user: \(error.localizedDescription)")
        }
    }
}

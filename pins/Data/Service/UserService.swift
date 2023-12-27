//
//  UserService.swift
//  pins
//
//  Created by 주동석 on 12/3/23.
//

import Foundation
import OSLog

protocol UserServiceProtocol {
    func getUser(id: String) async throws -> UserRequest?
    func putUser(user: UserRequest) throws
}

final class UserService: UserServiceProtocol {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func getUser(id: String) async throws -> UserRequest? {
        let decoder = JSONDecoder()
        let userData: [String: Any]
        do {
            userData = try await userRepository.getUser(id: id)
        } catch {
            os_log(.error, log: .default, "Error fetching user data: %@", error.localizedDescription)
            throw error
        }
        do {
            let user = try decoder.decode(UserRequest.self, from: JSONSerialization.data(withJSONObject: userData))
            return user
        } catch {
            os_log(.error, log: .default, "Error decoding user data: %@", error.localizedDescription)
            throw UserError.userDecodingError
        }
    }
    
    func putUser(user: UserRequest) throws {
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(user)
            let userDict = try JSONSerialization.jsonObject(with: userData) as? [String: Any]
            userRepository.putUser(user: userDict!)
        } catch {
            throw UserError.userDecodingError
        }
    }
}

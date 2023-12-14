//
//  KeychainManager.swift
//  pins
//
//  Created by 주동석 on 12/3/23.
//
import UIKit
import OSLog
import Security

enum KeychainManager: String {
    case userId
    case userEmail
    case userProfile
    
    static func saveImage(image: UIImage, forKey key: KeychainManager) {
        if let imageData = image.pngData() {
            let query: NSDictionary = [
                kSecValueData as String: imageData,
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.rawValue,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            SecItemDelete(query)
            let status = SecItemAdd(query, nil)
            if status != errSecSuccess {
                os_log("Failed to save image to keychain")
            }
        }
    }
    
    static func loadImage(forKey key: KeychainManager) -> UIImage? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            if let imageData = result as? Data {
                return UIImage(data: imageData)
            }
        }
        
        return nil
    }
    
    static func save(key: KeychainManager, string: String) {
        let query: NSDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData: string.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save Token")
    }

    static func load(key: KeychainManager) -> String? {
        let query: NSDictionary = [
           kSecClass: kSecClassGenericPassword,
           kSecAttrAccount: key.rawValue,
           kSecReturnData: kCFBooleanTrue as Any,
           kSecMatchLimit: kSecMatchLimitOne
       ]
       
       var dataTypeRef: AnyObject?
       let status = SecItemCopyMatching(query, &dataTypeRef)
       
       if status == errSecSuccess {
           let retrievedData = dataTypeRef as! Data
           let value = String(data: retrievedData, encoding: String.Encoding.utf8)
           return value
       } else {
           os_log("failed to loading, status code = \(status)")
           return nil
       }
    }
}

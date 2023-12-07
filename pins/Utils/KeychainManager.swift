//
//  KeychainManager.swift
//  pins
//
//  Created by 주동석 on 12/3/23.
//
import UIKit
import OSLog
import Security

final class KeychainManager {
    static func saveImage(image: UIImage, forKey key: String) {
        if let imageData = image.pngData() {
            let query: NSDictionary = [
                kSecValueData as String: imageData,
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            SecItemDelete(query)
            let status = SecItemAdd(query, nil)
            if status != errSecSuccess {
                os_log("Failed to save image to keychain")
            }
        }
    }
    
    static func loadImage(forKey key: String) -> UIImage? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
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
    
    static func save(key: String, string: String) {
        let query: NSDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData: string.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save Token")
    }

    static func load(key: String) -> String? {
        let query: NSDictionary = [
           kSecClass: kSecClassGenericPassword,
           kSecAttrAccount: key,
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

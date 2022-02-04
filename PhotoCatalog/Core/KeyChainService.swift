//
//  KeyChainService.swift
//  PhotoCatalog
//
//  Created by Islam on 04/02/2022.
//

import Foundation
import Security

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

protocol KeyChainAccessProtocol: AnyObject {
    associatedtype DataType
    func save(value: DataType)
    func load() -> DataType?
}

public class KeychainService {

    public func save(service: String, value: String) {
        self.save(service: service, data: value)
    }

    public func load(_ service: String) -> String? {
        return load(service: service)
    }

    private func save(service: String, data: String) {
        let dataFromString: Data? = data.data(using: .utf8, allowLossyConversion: false)!

        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, dataFromString as Any], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecValueDataValue])

        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)

        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    private func load(service: String) -> String? {

        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, kCFBooleanTrue as Any, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecReturnDataValue, kSecMatchLimitValue])

        var dataTypeRef :AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String? = nil

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: .utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }

        return contentsOfKeychain

    }
}

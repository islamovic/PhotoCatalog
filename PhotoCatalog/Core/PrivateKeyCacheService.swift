//
//  PrivateKeyCacheService.swift
//  PhotoCatalog
//
//  Created by Islam on 04/02/2022.
//

import Foundation

class PrivateKeyCache: KeyChainAccessProtocol {
    
    typealias DataType = String
    let privateKeyService = "privateKey"

    private let keychainService = KeychainService()

    func save(value: String) {
        keychainService.save(service: self.privateKeyService, value: value)
    }

    func load() -> String? {
        return keychainService.load(privateKeyService)
    }
}

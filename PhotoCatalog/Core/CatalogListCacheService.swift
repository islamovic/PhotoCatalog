//
//  CatalogListCacheService.swift
//  PhotoCatalog
//
//  Created by Islam on 04/02/2022.
//

import Foundation

class CatalogListCacheService: KeyChainAccessProtocol {

    typealias DataType = String
    let catalogListService = "listService"

    private let keychainService = KeychainService()


    func save(value: String) {
        keychainService.save(service: self.catalogListService, value: value)
    }

    func load() -> String? {
        return keychainService.load(catalogListService)
    }
}

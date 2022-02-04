//
//  CatalogListWorker.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import Foundation

enum CacheError: Error {
    case noCachedList
    case exportedPrivateKey
    case importedPrivateKey
    case symmetricKey
    case decoding
}

class CatalogListWorker {

    var maxId: String? = nil
    var sinceId: String? = nil

    init(maxId: String? = nil, sinceId: String? = nil) {
        self.maxId = maxId
        self.sinceId = sinceId
    }

    func fetchCachedList(completion: @escaping (Result<[CatalogItem], CacheError>) -> Void) {

        let catalogListCacheService = CatalogListCacheService()

        guard let cachedList = catalogListCacheService.load() else {
            completion(.failure(.noCachedList))
            return
        }

        let privateKeyCacheService = PrivateKeyCache()
        let dataEncryptionService = DataEncryption()

        let exportedPrivateKey = privateKeyCacheService.load()
        guard let exportedPrivateKey = exportedPrivateKey else {
            completion(.failure(.exportedPrivateKey))
            return
        }

        let importedPrivateKey = try? dataEncryptionService.importPrivateKey(exportedPrivateKey)
        guard let importedPrivateKey = importedPrivateKey else {
            completion(.failure(.importedPrivateKey))
            return
        }

        let publicKey = importedPrivateKey.publicKey
        let symmetricKey = try? dataEncryptionService.driveSymmetricKey(privateKey: importedPrivateKey, publicKey: publicKey)

        guard let symmetricKey = symmetricKey else {
            completion(.failure(.symmetricKey))
            return
        }
        let decoedString = dataEncryptionService.decrypt(text: cachedList, symmetricKey: symmetricKey)

        let decodedData = Data(decoedString.utf8)
        let catalogList = try? JSONDecoder().decode([CatalogItem].self, from: decodedData)
        guard let catalogList = catalogList else {
            completion(.failure(.decoding))
            return
        }
        completion(.success(catalogList))
    }

    func fetchCatalogList(completion: @escaping(Result<[CatalogItem], NetworkError>) -> Void) {

        let networkManager = NetworkManager()
        let router = CatalogListRouter()

        var params: [String: Any] = [:]
        if let maxId = maxId {
            params["max_id"] = maxId
        }
        if let sinceId = sinceId {
            params["since_id"] = sinceId
        }

        let request = router.buildRequest(parameters: params)
        networkManager.request(request: request) { result in
            completion(result)
        }
    }
}

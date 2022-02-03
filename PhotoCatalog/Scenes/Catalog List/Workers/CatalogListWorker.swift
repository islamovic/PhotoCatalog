//
//  CatalogListWorker.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import Foundation

class CatalogListWorker {

    var maxId: String? = nil
    var sinceId: String? = nil

    init(maxId: String? = nil, sinceId: String? = nil) {
        self.maxId = maxId
        self.sinceId = sinceId
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

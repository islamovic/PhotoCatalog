//
//  CatalogListWorker.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import Foundation

class CatalogListWorker {

    func fetchCatalogList(maxId: String? = nil, completion: @escaping(Result<[CatalogItem], NetworkError>) -> Void) {

        let networkManager = NetworkManager()

        let router = CatalogListRouter()

        var params: [String: Any] = [:]
        if let maxId = maxId {
            params["max_id"] = maxId
        }

        let request = router.buildRequest(parameters: params)

        networkManager.request(request: request) { result in
            completion(result)
        }
    }
}

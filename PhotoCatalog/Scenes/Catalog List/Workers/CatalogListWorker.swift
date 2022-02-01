//
//  CatalogListWorker.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import Foundation

class CatalogListWorker {

    func fetchCatalogList(completion: @escaping(Result<[CatalogItem], NetworkError>) -> Void) {

        let networkManager = NetworkManager()

        let router = CatalogListRouter()
        let request = router.buildRequest()

        networkManager.request(request: request) { result in
            completion(result)
        }
    }
}

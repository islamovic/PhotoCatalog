//
//  CreateCatalogWorker.swift
//  PhotoCatalog
//
//  Created by Islam on 02/02/2022.
//

import Foundation

class CreateCatalogWorker {

    func createCatalog(imageURL: String,
                       textDescription: String,
                       confidence: Float,
                       completion: @escaping(Result<CatalogItem, NetworkError>) -> Void) {

        let networkManager = NetworkManager()
        let router = CreatePhotoCatalogRouter()

        let params: [String: Any] = [
            "image": imageURL,
            "text": textDescription,
            "confidence": confidence
        ]
        
        let request = router.buildRequest(parameters: params)
        networkManager.request(request: request) { result in
            completion(result)
        }
    }
}

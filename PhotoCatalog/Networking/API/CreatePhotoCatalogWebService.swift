//
//  CreatePhotoCatalogWebService.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import Foundation

struct CreatePhotoCatalogRouter: Router {

    func buildRequest(with path: String? = nil,
                      parameters: [String: Any]? = [:],
                      method: HTTPMethod = .post,
                      headers: [String: String]? = [:]) -> URLRequest {

        var request = URLRequest(url: URL(string: baseURL ?? "")!)

        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }

        var allHeaders = ["Authorization": Constants.Client.token]
        if let headers = headers {
            for (key, value) in headers {
                allHeaders[key] = value
            }
        }
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = allHeaders
        return request
    }
}

class CreatePhotoCatalogWebService {

    private let createPhotoCatalog: CreatePhotoCatalogRouter
    private let networkManager: NetworkManager

    init(createPhotoCatalog: CreatePhotoCatalogRouter, networkManager: NetworkManager) {
        self.createPhotoCatalog = createPhotoCatalog
        self.networkManager = networkManager
    }
    
    func createPhoto(parameters: [String: Any]? = [:], completion: @escaping(Result<CatalogItem, NetworkError>) -> Void) {

        let request = createPhotoCatalog.buildRequest(parameters: parameters)

        networkManager.request(request: request) { (response: Result<CatalogItem, NetworkError>) in

            switch response {
            case .success(let catalog):
                completion(.success(catalog))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

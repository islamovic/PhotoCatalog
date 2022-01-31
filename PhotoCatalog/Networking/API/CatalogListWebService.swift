//
//  RetrieveCatalogList.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

struct CatalogListRouter: Router {

    func buildRequest(with path: String? = nil,
                      parameters: [String : Any]? = [:],
                      method: HTTPMethod = .get,
                      headers: [String : String]? = [:]) -> URLRequest {

        var components = URLComponents(string: baseURL ?? "")
        if let parameters = parameters {
            components?.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components?.queryItems!.append(queryItem)
            }
        }

        var request = URLRequest(url: components!.url!)
        request.httpMethod = method.rawValue
        var allHeaders = ["Authorization": Constants.Client.token]
        if let headers = headers {
            for (key, value) in headers {
                allHeaders[key] = value
            }
        }
        request.allHTTPHeaderFields = allHeaders
        return request
    }
}

class CatalogListWebService {

    private let catalogRouter: CatalogListRouter
    private let networkManager: NetworkManager

    init(catalogRouter: CatalogListRouter, networkManager: NetworkManager) {
        self.catalogRouter = catalogRouter
        self.networkManager = networkManager
    }

    func fetch(parameters: [String: Any]? = [:],
               completion: @escaping(Result<[CatalogItem], NetworkError>) -> Void) {

        let request = catalogRouter.buildRequest(parameters: parameters)

        networkManager.request(request: request) { (response: Result<[CatalogItem], NetworkError>) in

            switch response {
            case .success(let catalogList):
                completion(.success(catalogList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

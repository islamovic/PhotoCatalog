//
//  Router.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

protocol Router {
    func buildRequest(
        with path: String?,
        parameters: [String: Any]?,
        method: HTTPMethod,
        headers: [String: String]?) -> URLRequest
}

extension Router {
    var baseURL: String? {
        return Constants.Server.baseUrl
    }
}

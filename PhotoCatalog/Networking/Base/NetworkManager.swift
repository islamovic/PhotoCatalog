//
//  NetworkManager.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation
import UIKit

enum NetworkError: Equatable, Error {

    case decoding
    case failedRequest
    case invalidData

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

protocol NetworkClient {
    func request<T: Decodable>(request: URLRequest, completion: @escaping (Result<[T], NetworkError>) -> Void)

    func downloadImage(url: URL, completion: @escaping(Result<UIImage?, NetworkError>) -> Void)
}

class NetworkManager: NetworkClient {

    private var session: URLSession
    private var decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func request<T: Decodable>(request: URLRequest,
                    completion: @escaping (Result<T, NetworkError>) -> Void) {

        let dataTask = session.dataTask(with: request) { (data, response, error) in

            if error != nil {
                completion(.failure(.failedRequest))
                return
            }

            guard let safeData = data, let response = try? self.decoder.decode(T.self, from: safeData) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(response))
        }

        dataTask.resume()
    }

    func downloadImage(url: URL, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {

        let dataTask = session.dataTask(with: url) { (data, response, error) in

            if error != nil {
                completion(.failure(.failedRequest))
                return
            }

            guard let safeData = data else {
                completion(.failure(.invalidData))
                return
            }

            let image = UIImage(data: safeData)
            completion(.success(image))
        }
        dataTask.resume()
    }
}

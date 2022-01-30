//
//  NetworkManager.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

enum NetworkError: Error {
    case decoding
    case invalidData
    case networking(Error)
}

protocol NetworkClient {
    func request<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkManager: NetworkClient {

    private var session: URLSession
    private var decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(request: URLRequest,
                    completion: @escaping (Result<T, NetworkError>) -> Void) {

        let dataTask = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion(.failure(.networking(error)))
                return
            }

            guard let safeData = data,
                  let response = try? self.decoder.decode(T.self, from: safeData) else {
                      if data != nil {
                          completion(.failure(.decoding))
                          return
                      }
                      completion(.failure(.decoding))
                      return
                  }
            completion(.success(response))
        }

        dataTask.resume()
    }
}

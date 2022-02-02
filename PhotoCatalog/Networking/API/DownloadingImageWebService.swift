//
//  DownloadingImageWebService.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import Foundation
import UIKit

class DownloadingImageWebService {

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func downloadImage(from url: String, completion: @escaping(Result<UIImage?, NetworkError>) -> Void) {
        let escapedString = url.replacingOccurrences(of: " ", with: "%20")
        networkManager.downloadImage(url: URL(string: escapedString)!) { result in
            completion(result)
        }
    }
}

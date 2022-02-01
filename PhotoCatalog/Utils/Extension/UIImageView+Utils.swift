//
//  UIImageView+Utils.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import Foundation
import UIKit

extension UIImageView {

    func setImage(from url: String, placeholder: UIImage? = nil) {

        let networkManager = NetworkManager()
        let downloadingImageWebService = DownloadingImageWebService(networkManager: networkManager)

        downloadingImageWebService.downloadImage(from: url) { result in

            switch result {

            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.image = nil
                }
            }
        }
    }
}

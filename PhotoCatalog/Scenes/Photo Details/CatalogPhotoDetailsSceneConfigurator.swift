//
//  PhotoDetailsSceneConfigurator.swift
//  PhotoCatalog
//
//  Created by Islam on 02/02/2022.
//

import Foundation
import UIKit

class CatalogPhotoDetailsSceneConfigurator: SceneConfigurator {

    typealias Parameter = CatalogItem

    func configure(parameter: CatalogItem?) -> UIViewController {
        let viewController = CatalogPhotoDetailsViewController()
        viewController.catalogItem = parameter
        return viewController
    }
}

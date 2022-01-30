//
//  CatalogListSceneConfigurator.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation
import UIKit

class CatalogListSceneConfigurator: SceneConfigurator {

    func configure() -> UIViewController? {

        let viewController = CatalogListViewController()

        return viewController
    }
}

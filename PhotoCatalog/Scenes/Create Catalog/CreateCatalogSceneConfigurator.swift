//
//  CreateCatalogSceneConfigurator.swift
//  PhotoCatalog
//
//  Created by Islam on 02/02/2022.
//

import Foundation
import UIKit

class CreateCatalogSceneConfigurator: SceneConfigurator {

    typealias Parameter = CatalogItem

    func configure(parameter: CatalogItem? = nil) -> UIViewController {
        let viewController = CreateCatalogViewController()
        let presenter = CreateCatalogScenePresenter(displayView: viewController)
        let interactor = CreateCatalogSceneInteractor(presenter: presenter)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        return viewController
    }
}

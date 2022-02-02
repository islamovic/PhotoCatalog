//
//  CatalogListSceneRouter.swift
//  PhotoCatalog
//
//  Created by Islam on 02/02/2022.
//

import Foundation

protocol CatalogListSceneRoutingLogic: AnyObject {
    typealias Controller = CatalogListSceneDisplayView & CatalogListViewController

    func routeToCreateNewImage()
}

class CatalogListSceneRouter: CatalogListSceneRoutingLogic {

    // MARK: - Stored Properties
    weak var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        viewController = controller
    }
}

extension CatalogListSceneRouter {

    func routeToCreateNewImage() {
        let createCatalogItemViewConfigurator = CreateCatalogSceneConfigurator()
        let createCatalogItemViewController = createCatalogItemViewConfigurator.configure()
        viewController?.navigationController?.pushViewController(createCatalogItemViewController, animated: true)
    }
}

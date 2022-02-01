//
//  CatalogListScenePresenter.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

protocol CatalogListScenePresentaionLogic: AnyObject {

    func presentCatalogListSuccess(indeces: [IndexPath])
    func presentCatalogListFailure(_ error: NetworkError)
    func presentCatalogListAfterRefreshing()
}

class CatalogListScenePresenter: CatalogListScenePresentaionLogic {

    // MARK: - Stored Properties
    weak var displayView: CatalogListSceneDisplayView?

    // MARK: - Initializers
    required init(displayView: CatalogListSceneDisplayView) {
        self.displayView = displayView
    }
}

extension CatalogListScenePresenter {

    func presentCatalogListSuccess(indeces: [IndexPath]) {
        self.displayView?.displayCatalogListSucess(indeces: indeces)
    }

    func presentCatalogListFailure(_ error: NetworkError) {
        self.displayView?.displayCatalogListFailure(error)
    }

    func presentCatalogListAfterRefreshing() {
        self.displayView?.displayCatalogListAfterRefreshing()
    }
}

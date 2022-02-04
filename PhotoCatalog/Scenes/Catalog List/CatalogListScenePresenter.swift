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

    func presentCachedCatalogListSuccess(indeces: [IndexPath])
    func presentCachedCatalogListFailure()
}

class CatalogListScenePresenter: CatalogListScenePresentaionLogic {

    // MARK: - Stored Properties
    weak var displayView: CatalogListSceneDisplayView?

    // MARK: - Initializers
    required init(displayView: CatalogListSceneDisplayView) {
        self.displayView = displayView
    }

    func presentCatalogListSuccess(indeces: [IndexPath]) {
        self.displayView?.displayCatalogListSucess(indeces: indeces)
    }

    func presentCatalogListFailure(_ error: NetworkError) {
        self.displayView?.displayCatalogListFailure(error)
    }

    func presentCatalogListAfterRefreshing() {
        self.displayView?.displayCatalogListAfterRefreshing()
    }

    func presentCachedCatalogListSuccess(indeces: [IndexPath]) {
        self.displayView?.displayViewCatalogCachedListSuccess(indeces: indeces)
    }

    func presentCachedCatalogListFailure() {
        self.displayView?.displayViewCatalogCachedListFailure()
    }
}

//
//  CatalogListScenePresenter.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

protocol CatalogListScenePresentaionLogic: AnyObject {

}

class CatalogListScenePresenter: CatalogListScenePresentaionLogic {

    // MARK: - Stored Properties
    weak var displayView: CatalogListSceneDisplayView?

    // MARK: - Initializers
    required init(displayView: CatalogListSceneDisplayView) {
        self.displayView = displayView
    }
}

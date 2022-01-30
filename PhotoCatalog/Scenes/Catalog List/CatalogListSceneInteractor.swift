//
//  CatalogListSceneInteractor.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

protocol CatalogListSceneDataStore: AnyObject {

}

protocol CatalogListSceneBusinessLogic: AnyObject {

}

class CatalogListSceneInteractor: CatalogListSceneBusinessLogic, CatalogListSceneDataStore {

    // MARK: - Stored Properties
    let presenter: CatalogListScenePresentaionLogic?

    // MARK: - Initializers
    required init(presenter: CatalogListScenePresentaionLogic) {
        self.presenter = presenter
    }
}

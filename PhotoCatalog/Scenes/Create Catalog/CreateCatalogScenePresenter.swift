//
//  CreateCatalogScenePresenter.swift
//  PhotoCatalog
//
//  Created by Islam on 02/02/2022.
//

import Foundation

protocol CreateCatalogScenePresentaionLogic: AnyObject {

    func presentCreateCatalogPhotoSuccess()
    func presentCreateCatalogPhotoFailure()
}

class CreateCatalogScenePresenter: CreateCatalogScenePresentaionLogic {

    // MARK: - Stored Properties
    weak var displayView: CreateCatalogSceneDisplayView?

    // MARK: - Initializers
    required init(displayView: CreateCatalogSceneDisplayView) {
        self.displayView = displayView
    }

    func presentCreateCatalogPhotoSuccess() {
        self.displayView?.displayViewCreateCatalogPhotoSuccess()
    }

    func presentCreateCatalogPhotoFailure() {
        self.displayView?.displayViewCreateCatalogPhotoFailure()
    }

}

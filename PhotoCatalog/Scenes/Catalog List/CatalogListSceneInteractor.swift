//
//  CatalogListSceneInteractor.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

protocol CatalogListSceneDataStore: AnyObject {

    var catalogList: [CatalogItem] { get set }
}

protocol CatalogListSceneBusinessLogic: AnyObject {

    func fetchCatalogList()
}

class CatalogListSceneInteractor: CatalogListSceneBusinessLogic, CatalogListSceneDataStore {

    // MARK: - Stored Properties
    let presenter: CatalogListScenePresentaionLogic?

    let worker: CatalogListWorker

    var catalogList: [CatalogItem] = []

    // MARK: - Initializers
    required init(presenter: CatalogListScenePresentaionLogic) {
        self.presenter = presenter
        self.worker = CatalogListWorker()
    }
}

extension CatalogListSceneInteractor {

    func fetchCatalogList() {

        worker.fetchCatalogList { [weak self] result in
            switch result {
            case .success(let catalogList):
                self?.catalogList = catalogList
                self?.presenter?.presentCatalogListSuccess()
            case .failure(let error):
                self?.presenter?.presentCatalogListFailure(error)
            }
        }
    }
}

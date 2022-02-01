//
//  CatalogListSceneInteractor.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

protocol CatalogListSceneDataStore: AnyObject {

    var catalogList: [CatalogItem] { get set }

    var maxId: String? { get set }
}

protocol CatalogListSceneBusinessLogic: AnyObject {

    func fetchCatalogList()

    func detectLoadingMore(index: Int)
}

class CatalogListSceneInteractor: CatalogListSceneBusinessLogic, CatalogListSceneDataStore {

    // MARK: - Stored Properties
    let presenter: CatalogListScenePresentaionLogic?

    let worker: CatalogListWorker

    var catalogList: [CatalogItem] = []

    var maxId: String? = nil

    // MARK: - Initializers
    required init(presenter: CatalogListScenePresentaionLogic) {
        self.presenter = presenter
        self.worker = CatalogListWorker()
    }
}

extension CatalogListSceneInteractor {

    func fetchCatalogList() {

        worker.fetchCatalogList(maxId: self.maxId) { [weak self] result in
            switch result {
            case .success(let catalogList):

                if catalogList.count != 0 {
                    var indeces: [IndexPath] = []
                    let start = self?.catalogList.count ?? 0
                    let end = catalogList.count + start - 1

                    for index in start..<end {
                        indeces.append(IndexPath(row: index, section: 0))
                    }
                    self?.catalogList.append(contentsOf: catalogList)
                    self?.presenter?.presentCatalogListSuccess(indeces: indeces)
                }
            case .failure(let error):
                self?.presenter?.presentCatalogListFailure(error)
            }
        }
    }

    func detectLoadingMore(index: Int) {
        if index == self.catalogList.count - 1 {
            self.maxId = self.catalogList.last?.identifier
            self.fetchCatalogList()
        }
    }

}

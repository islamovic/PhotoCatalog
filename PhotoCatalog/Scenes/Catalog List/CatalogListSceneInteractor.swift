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

    var sinceId: String? { get set }
}

protocol CatalogListSceneBusinessLogic: AnyObject {

    func fetchCatalogList()

    func detectLoadingMore(index: Int)

    func fetchRecentCatalogList()
}

class CatalogListSceneInteractor: CatalogListSceneBusinessLogic, CatalogListSceneDataStore {

    // MARK: - Stored Properties
    var presenter: CatalogListScenePresentaionLogic?

    var worker = CatalogListWorker()

    var catalogList: [CatalogItem] = []

    var maxId: String? = nil

    var sinceId: String? = nil

    // MARK: - Initializers
    required init(presenter: CatalogListScenePresentaionLogic) {
        self.presenter = presenter
    }
}

extension CatalogListSceneInteractor {

    func fetchCatalogList() {

        worker.fetchCatalogList() { [weak self] result in

            switch result {

            case .success(let catalogList):

                if catalogList.count != 0 {

                    if self?.maxId != nil {
                        let indeces = self?.updateOlderCatalogList(catalogList: catalogList) ?? []
                        self?.presenter?.presentCatalogListSuccess(indeces: indeces)
                        self?.catalogList.append(contentsOf: catalogList)
                        return
                    } else {
                        let indeces = self?.updateRecentCatalogList(catalogList: catalogList) ?? []
                        self?.presenter?.presentCatalogListSuccess(indeces: indeces)
                        self?.catalogList.insert(contentsOf: catalogList, at: 0)
                        return
                    }
                } else {
                    self?.presenter?.presentCatalogListAfterRefreshing()
                }
            case .failure(let error):
                self?.presenter?.presentCatalogListFailure(error)
            }
        }
    }

    func detectLoadingMore(index: Int) {
        self.sinceId = nil
        if index == self.catalogList.count - 1 {
            self.maxId = self.catalogList.last?.identifier
            self.worker.maxId = maxId
            self.fetchCatalogList()
        }
    }

    func fetchRecentCatalogList() {
        self.maxId = nil
        self.sinceId = self.catalogList.first?.identifier
        self.worker.sinceId = sinceId
        self.fetchCatalogList()
    }
}

private extension CatalogListSceneInteractor {

    func updateOlderCatalogList(catalogList: [CatalogItem]) -> [IndexPath] {
        var indeces: [IndexPath] = []
        let start = self.catalogList.count
        let end = catalogList.count + start - 1

        for index in start..<end {
            indeces.append(IndexPath(row: index, section: 0))
        }
        return indeces
    }

    func updateRecentCatalogList(catalogList: [CatalogItem]) -> [IndexPath] {

        var indeces: [IndexPath] = []
        let start = 0
        let end = catalogList.count + start - 1

        for index in start..<end {
            indeces.append(IndexPath(row: index, section: 0))
        }
        return indeces
    }
}

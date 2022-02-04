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

    func detectLoadingMore(index: Int) -> Bool

    func fetchRecentCatalogList()

    func fetchCachedCatalogList()

    func cacheMostRecentCatalogList()
}

class CatalogListSceneInteractor: CatalogListSceneBusinessLogic, CatalogListSceneDataStore {

    // MARK: - Stored Properties
    var presenter: CatalogListScenePresentaionLogic?

    var worker = CatalogListWorker()

    let dataEncryption = DataEncryption()

    var catalogList: [CatalogItem] = []

    var maxId: String? = nil

    var sinceId: String? = nil

    // MARK: - Initializers
    required init(presenter: CatalogListScenePresentaionLogic) {
        self.presenter = presenter
    }

    func fetchCatalogList() {

        worker.fetchCatalogList() { [weak self] result in

            switch result {

            case .success(let catalogList):
                if catalogList.count != 0 {
                    if self?.maxId != nil {
                        self?.updateOldCatalogList(catalogList)
                        return
                    } else {
                        self?.updateRecentsCatalogList(catalogList)
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

    func fetchCachedCatalogList() {
        worker.fetchCachedList { [weak self] result in

            switch result {
            case .success(let catalogList):
                self?.updateRecentsCatalogList(catalogList)
                break

            case .failure:
                self?.presenter?.presentCachedCatalogListFailure()
                break
            }
        }
    }

    func cacheMostRecentCatalogList() {

        let catalogListCacheService = CatalogListCacheService()
        let privateKeyCacheService = PrivateKeyCache()
        let dataEncryptionService = DataEncryption()

        let mostRecentCatalogList = Array(self.catalogList[0...9])
        guard let encodedData = try? JSONEncoder().encode(mostRecentCatalogList) else { return }
        guard let encodedString = String(data: encodedData, encoding: .utf8) else { return }

        guard let exportedPrivateKey = privateKeyCacheService.load() else { return }
        guard let importedPrivateKey = try? dataEncryptionService.importPrivateKey(exportedPrivateKey) else { return }

        let publicKey = importedPrivateKey.publicKey
        guard let symmetricKey = try? dataEncryptionService.driveSymmetricKey(privateKey: importedPrivateKey, publicKey: publicKey) else { return }
        guard let encryptedData = try? dataEncryptionService.encrypt(text: encodedString, symmetricKey: symmetricKey) else { return }

        catalogListCacheService.save(value: encryptedData)
    }

    func detectLoadingMore(index: Int) -> Bool {
        self.sinceId = nil
        if index == self.catalogList.count - 1 {
            self.maxId = self.catalogList.last?.identifier
            self.worker.maxId = maxId
            return true
        }
        return false
    }

    func fetchRecentCatalogList() {
        self.maxId = nil
        self.sinceId = self.catalogList.first?.identifier
        self.worker.sinceId = sinceId
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

    func updateRecentsCatalogList(_ catalogList: [CatalogItem]) {
        let indeces = self.updateRecentCatalogList(catalogList: catalogList)
        self.presenter?.presentCatalogListSuccess(indeces: indeces)
        self.catalogList.insert(contentsOf: catalogList, at: 0)
    }

    func updateOldCatalogList(_ catalogList: [CatalogItem]) {
        let indeces = self.updateOlderCatalogList(catalogList: catalogList)
        self.presenter?.presentCatalogListSuccess(indeces: indeces)
        self.catalogList.append(contentsOf: catalogList)
    }
}

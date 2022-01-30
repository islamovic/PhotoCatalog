//
//  CatalogListViewController.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import UIKit

protocol CatalogListSceneDisplayView: AnyObject {

}

class CatalogListViewController: UIViewController {

    var interactor: CatalogListSceneInteractor!
    var dataStore: CatalogListSceneDataStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalofListRouter = CatalogListRouter()
        let networkManager = NetworkManager()
        let catalogEndPoint = CatalogList(catalogRouter: catalofListRouter, networkManager: networkManager)
        catalogEndPoint.fetch { result in

        }
    }
}

extension CatalogListViewController: CatalogListSceneDisplayView {
    
}

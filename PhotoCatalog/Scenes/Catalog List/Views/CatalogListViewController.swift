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

//        let catalofListRouter = CatalogListRouter()
//        let networkManager = NetworkManager()
//        let catalogEndPoint = CatalogListWebService(catalogRouter: catalofListRouter, networkManager: networkManager)
//        catalogEndPoint.fetch { result in
//
//        }

        let createPhotoCatalog = CreatePhotoCatalogRouter()
        let networkManager = NetworkManager()
        let createPhotoEndPoint = CreatePhotoCatalogWebService(createPhotoCatalog: createPhotoCatalog,
                                                               networkManager: networkManager)
        let params = [
            "image": "https://via.placeholder.com/512x512?text=Hello+from+app!",
            "text": "Hello from app",
            "confidence": 0.8
        ] as [String : Any]
        
        createPhotoEndPoint.createPhoto(parameters: params) { result in
            print(result)
        }
    }
}

extension CatalogListViewController: CatalogListSceneDisplayView {
    
}

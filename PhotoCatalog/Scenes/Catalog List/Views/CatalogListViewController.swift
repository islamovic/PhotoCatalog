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
    }
}

extension CatalogListViewController: CatalogListSceneDisplayView {
    
}

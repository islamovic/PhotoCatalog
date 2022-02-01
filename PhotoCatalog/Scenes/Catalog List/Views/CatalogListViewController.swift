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

    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    
    var interactor: CatalogListSceneInteractor!
    var dataStore: CatalogListSceneDataStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeUI()
    }
}

extension CatalogListViewController: CatalogListSceneDisplayView {
    
}

extension CatalogListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoCatalogCell = tableView.dequeueReusableCell(indexPath: indexPath)
        return cell
    }
}

extension CatalogListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension CatalogListViewController {

    func initializeUI() {

        self.tableView.frame = .zero
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PhotoCatalogCell.self)
    }
}

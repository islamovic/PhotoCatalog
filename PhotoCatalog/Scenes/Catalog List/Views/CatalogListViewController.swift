//
//  CatalogListViewController.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import UIKit

protocol CatalogListSceneDisplayView: AnyObject {

    func displayCatalogListSucess()
    func displayCatalogListFailure(_ error: NetworkError)
}

class CatalogListViewController: UIViewController {

    private let numberOfColumns: Int = 2
    private let itemHeight: CGFloat = 200

    // MARK: - Outlets
    @IBOutlet private var collectionView: UICollectionView!
    
    var interactor: CatalogListSceneInteractor!
    var dataStore: CatalogListSceneDataStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeUI()
        self.interactor.fetchCatalogList()
    }
}

extension CatalogListViewController: CatalogListSceneDisplayView {

    func displayCatalogListSucess() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    func displayCatalogListFailure(_ error: NetworkError) {

    }
}

extension CatalogListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataStore.catalogList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCatalogCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let selectedCatalogItem = self.dataStore.catalogList[indexPath.row]
        cell.configureCell(catalogItem: selectedCatalogItem)
        return cell
    }
}

extension CatalogListViewController: UICollectionViewDelegate {

}

private extension CatalogListViewController {

    func initializeUI() {

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(PhotoCatalogCell.self)
        self.collectionView.collectionViewLayout = catalogPhotoListLayout
    }

    var catalogPhotoListLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfColumns)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

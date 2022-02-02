//
//  CatalogListViewController.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import UIKit

protocol CatalogListSceneDisplayView: AnyObject {

    func displayCatalogListSucess(indeces: [IndexPath])
    func displayCatalogListFailure(_ error: NetworkError)
    func displayCatalogListAfterRefreshing()
}

class CatalogListViewController: UIViewController {

    private let numberOfColumns: Int = 2
    private let itemHeight: CGFloat = 200

    private let refreshControl = UIRefreshControl()

    // MARK: - Outlets
    @IBOutlet private var collectionView: UICollectionView!
    
    var interactor: CatalogListSceneInteractor!
    var dataStore: CatalogListSceneDataStore!
    var router: CatalogListSceneRouter!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeUI()
        self.initializeRefreshControl()

        self.refreshControl.beginRefreshing()
        self.interactor.fetchRecentCatalogList()
    }

    @objc func refresh(sender: UIRefreshControl) {
        self.interactor.fetchRecentCatalogList()
    }

    @objc func createPhotoCatalog(sender: UITabBarItem) {
        router.routeToCreateNewImage()
    }
}

extension CatalogListViewController: CatalogListSceneDisplayView {

    func displayCatalogListSucess(indeces: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.performBatchUpdates({
                self?.collectionView.insertItems(at: indeces)
            }, completion: nil)
        }
    }

    func displayCatalogListFailure(_ error: NetworkError) {

    }

    func displayCatalogListAfterRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        self.interactor.detectLoadingMore(index: indexPath.row)
    }
}

private extension CatalogListViewController {

    func initializeUI() {

        self.title = "Catalog List"
        let createPostBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                  action: #selector(createPhotoCatalog))
        self.navigationItem.rightBarButtonItem = createPostBarButton

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(PhotoCatalogCell.self)
        self.collectionView.collectionViewLayout = catalogPhotoListLayout
    }

    func initializeRefreshControl() {
        self.refreshControl.tintColor = .black
        self.refreshControl.addTarget(self, action: #selector(refresh) , for: .valueChanged)
        collectionView.addSubview(self.refreshControl)
        collectionView.alwaysBounceVertical = true
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

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

    func displayViewCatalogCachedListSuccess(indeces: [IndexPath])
    func displayViewCatalogCachedListFailure()
}

class CatalogListViewController: UIViewController {

    private var numberOfColumns: Int = 2
    private let itemHeight: CGFloat = 200

    private let refreshControl = UIRefreshControl()

    // MARK: - Outlets
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var errorMessage: UIView!
    
    var interactor: CatalogListSceneInteractor!
    var dataStore: CatalogListSceneDataStore!
    var router: CatalogListSceneRouter!

    private let portraitNumberOfColumns = 2
    private let landscapeNumberOfColumns = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeUI()
        self.initializeRefreshControl()

        self.refreshControl.beginRefreshing()
        self.interactor.fetchCachedCatalogList()
    }

    // switch between 2 or 3 cells in case of portraint and landscape view.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.numberOfColumns = portraitNumberOfColumns
        } else {
            self.numberOfColumns = landscapeNumberOfColumns
        }

        self.collectionView.collectionViewLayout = catalogPhotoListLayout
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    @objc func refresh(sender: UIRefreshControl) {
        self.interactor.fetchRecentCatalogList()
        self.interactor.fetchCatalogList()
    }

    @objc func createPhotoCatalog(sender: UITabBarItem) {
        router.routeToCreateNewImage()
    }
}

// MARK: - Display View for updating the UI.

extension CatalogListViewController: CatalogListSceneDisplayView {

    func displayCatalogListSucess(indeces: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.performBatchUpdates({
                self?.interactor.cacheMostRecentCatalogList()
                self?.collectionView.insertItems(at: indeces)
            }, completion: { [weak self] completed in
                self?.errorMessage.isHidden = true
                self?.refreshControl.endRefreshing()
            })
        }
    }

    func displayCatalogListFailure(_ error: NetworkError) {
        if self.dataStore.catalogList.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage.isHidden = false
                self?.refreshControl.endRefreshing()
            }
        }
    }

    func displayCatalogListAfterRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }


    func displayViewCatalogCachedListSuccess(indeces: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.performBatchUpdates({
                self?.collectionView.insertItems(at: indeces)
            }, completion: { [weak self] completed in
                self?.errorMessage.isHidden = true
                self?.refreshControl.endRefreshing()
            })
        }
    }

    func displayViewCatalogCachedListFailure() {
        self.interactor.fetchRecentCatalogList()
        self.interactor.fetchCatalogList()
    }
}

// MARK: - Table View data source
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

// MARK: - Table View Delegate
extension CatalogListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let isLoadingMore = self.interactor.detectLoadingMore(index: indexPath.row)
        if isLoadingMore {
            self.interactor.fetchCatalogList()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCatalogItem = self.dataStore.catalogList[indexPath.row]
        self.router.routeToCatalogPhotoDetails(selectedCatalogItem)
    }
}

// MARK: - Private helper methods.
private extension CatalogListViewController {

    func initializeUI() {

        self.title = "Catalog List"
        let createPostBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                  action: #selector(createPhotoCatalog))
        self.navigationItem.rightBarButtonItem = createPostBarButton

        self.errorMessage.isHidden = true
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

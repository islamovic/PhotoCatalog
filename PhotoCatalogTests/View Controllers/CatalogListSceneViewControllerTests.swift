//
//  CatalogListSceneViewControllerTests.swift
//  PhotoCatalogTests
//
//  Created by Islam on 03/02/2022.
//

import XCTest
@testable import PhotoCatalog


class CatalogListSceneViewControllerTests: XCTestCase {

    var sut: CatalogListViewController!

    override func setUp() {
        sut = CatalogListViewController()
    }

    override func tearDown() {
        sut = nil
    }

    func testCatalogListSceneLoadMore() {

        // Given
        let presenter = CatalogListScenePresenter(displayView: sut)
        let interactor = CatalogListSceneInteractor(presenter: presenter)

        sut.interactor = interactor

        interactor.catalogList = [
            CatalogItem(identifier: "61f9a61bd82c7", text: "", confidence: 0.7, image: ""),
            CatalogItem(identifier: "61f99bece4744", text: "", confidence: 0.7, image: "")
        ]

        // When
        let isLoadingMore = sut.interactor.detectLoadingMore(index: interactor.catalogList.count - 1)

        // Then
        XCTAssertTrue(isLoadingMore)
    }
}

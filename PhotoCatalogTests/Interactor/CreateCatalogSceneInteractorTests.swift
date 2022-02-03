//
//  CreateCatalogSceneInteractorTests.swift
//  PhotoCatalogTests
//
//  Created by Islam on 03/02/2022.
//

import XCTest
@testable import PhotoCatalog

class CreateCatalogSceneWorkerSuccessfullDummy: CreateCatalogWorker {

    override func createCatalog(imageURL: String, textDescription: String, confidence: Float, completion: @escaping (Result<CatalogItem, NetworkError>) -> Void) {

        let catalogItem = CatalogItem(identifier: "", text: "", confidence: 1.0, image: "")
        completion(.success(catalogItem))
    }
}

class CreateCatalogSceneWorkerFailureDummy: CreateCatalogWorker {

    override func createCatalog(imageURL: String, textDescription: String, confidence: Float, completion: @escaping (Result<CatalogItem, NetworkError>) -> Void) {

        completion(.failure(.invalidData))
    }
}

class CreateCatalogScenePresenterSpy: CreateCatalogScenePresenter {

    var catalogItem: CatalogItem!

    var error: NetworkError!

    override func presentCreateCatalogPhotoSuccess() {
        let catalogItem = CatalogItem(identifier: "", text: "", confidence: 1.0, image: "")
        self.catalogItem = catalogItem
    }

    override func presentCreateCatalogPhotoFailure() {
        self.error = .failedRequest
    }
}

class CreateCatalogSceneInteractorTests: XCTestCase {

    var sut: CreateCatalogSceneInteractor!

    override func tearDown() {
        sut = nil
    }

    func testCreateCatalogSceneInteractor_GivenSuccessResposne_ReturnSuccess() {

        let viewController = CreateCatalogViewController()

        let presenterSpy = CreateCatalogScenePresenterSpy(displayView: viewController)

        let workerDummy = CreateCatalogSceneWorkerSuccessfullDummy()

        sut = CreateCatalogSceneInteractor(presenter: presenterSpy)

        sut.worker = workerDummy

        sut.createCatalogPhoto()

        XCTAssertEqual(presenterSpy.catalogItem.identifier, "")
    }

    func testCreateCatalogSceneInteractor_GivenFailureResposne_ReturnFailure() {

        let viewController = CreateCatalogViewController()

        let presenterSpy = CreateCatalogScenePresenterSpy(displayView: viewController)

        let workerDummy = CreateCatalogSceneWorkerFailureDummy()

        sut = CreateCatalogSceneInteractor(presenter: presenterSpy)

        sut.worker = workerDummy

        sut.createCatalogPhoto()

        XCTAssertEqual(presenterSpy.error, .failedRequest)
    }
}

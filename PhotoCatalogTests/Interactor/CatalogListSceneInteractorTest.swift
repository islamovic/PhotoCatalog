//
//  CatalogListSceneInteractor.swift
//  PhotoCatalogTests
//
//  Created by Islam on 03/02/2022.
//

import XCTest
@testable import PhotoCatalog

class CatalogListWorkerEmptySuccessDummy: CatalogListWorker {

    override func fetchCatalogList(completion: @escaping (Result<[CatalogItem], NetworkError>) -> Void) {
        completion(.success([]))
    }
}

class CatalogListWorkerNotEmptySuccessDummy: CatalogListWorker {

    override func fetchCatalogList(completion: @escaping (Result<[CatalogItem], NetworkError>) -> Void) {
        completion(.success([CatalogItem(identifier: "", text: "", confidence: 1.0, image: "")]))
    }
}

class CatalogListWorkerNotEmptyWithMaxParametersSuccessDummy: CatalogListWorker {

    override func fetchCatalogList(completion: @escaping (Result<[CatalogItem], NetworkError>) -> Void) {
        completion(.success([CatalogItem(identifier: "", text: "", confidence: 1.0, image: "")]))
    }
}

class CatalogListWorkerNotEmptyWithSinceParametersSuccessDummy: CatalogListWorker {

    override func fetchCatalogList(completion: @escaping (Result<[CatalogItem], NetworkError>) -> Void) {
        completion(.success([
            CatalogItem(identifier: "", text: "", confidence: 1.0, image: ""),
            CatalogItem(identifier: "", text: "", confidence: 1.0, image: ""),
            CatalogItem(identifier: "", text: "", confidence: 1.0, image: ""),
            CatalogItem(identifier: "", text: "", confidence: 1.0, image: "")
        ]))
    }
}


class CatalogListWorkerFailureDummy: CatalogListWorker {

    override func fetchCatalogList(completion: @escaping (Result<[CatalogItem], NetworkError>) -> Void) {
        completion(.failure(.invalidData))
    }
}

class CatalogListScenePresenterSpy: CatalogListScenePresenter {

    var list: [CatalogItem] = []

    var responseError: NetworkError = .failedRequest

    override func presentCatalogListAfterRefreshing() {
        list = []
    }

    override func presentCatalogListSuccess(indeces: [IndexPath]) {
        list = [
            CatalogItem(identifier: "", text: "", confidence: 1.0, image: "")
        ]
    }

    override func presentCatalogListFailure(_ error: NetworkError) {
        self.responseError = .invalidData
    }
}

class CatalogListInteractorTests: XCTestCase {

    var sut: CatalogListSceneInteractor!

    override func tearDown() {
        sut = nil
    }

    func testFetchCatalogList_GivenSuccessfulResponse_ReturnEmptyResult() {

        let viewController = CatalogListViewController()

        let presnterSpy = CatalogListScenePresenterSpy(displayView: viewController)

        let workerDummy = CatalogListWorkerEmptySuccessDummy()

        sut = CatalogListSceneInteractor(presenter: presnterSpy)

        sut.worker = workerDummy

        sut.fetchCatalogList()

        XCTAssertEqual(presnterSpy.list.count, 0)
    }

    func testFetchCatalogList_GivenSuccessfulResponse_ReturnResultList() {

        let viewController = CatalogListViewController()

        let presnterSpy = CatalogListScenePresenterSpy(displayView: viewController)

        let workerDummy = CatalogListWorkerNotEmptySuccessDummy()

        sut = CatalogListSceneInteractor(presenter: presnterSpy)

        sut.worker = workerDummy

        sut.fetchCatalogList()

        XCTAssertEqual(presnterSpy.list.count, 1)
    }

    func testFetchCatalogList_GivenFailureResponse_ReturnFailure() {

        let viewController = CatalogListViewController()

        let presnterSpy = CatalogListScenePresenterSpy(displayView: viewController)

        let workerDummy = CatalogListWorkerFailureDummy()

        sut = CatalogListSceneInteractor(presenter: presnterSpy)

        sut.worker = workerDummy

        sut.fetchCatalogList()

        XCTAssertEqual(presnterSpy.responseError, .invalidData)
    }

    func testFetchCatalogList_GivenMaxIdParameters_ReturnSuccess() {

        let viewController = CatalogListViewController()

        let presnterSpy = CatalogListScenePresenterSpy(displayView: viewController)

        let workerDummy = CatalogListWorkerNotEmptyWithMaxParametersSuccessDummy(maxId: "32654268")

        sut = CatalogListSceneInteractor(presenter: presnterSpy)

        sut.worker = workerDummy

        sut.fetchCatalogList()

        XCTAssertEqual(presnterSpy.list.count, 1)
    }

    func testFettchCatalogList_GivenSinceIdParameters_ReturnSuccess() {

        let viewController = CatalogListViewController()

        let presnterSpy = CatalogListScenePresenterSpy(displayView: viewController)

        let workerDummy = CatalogListWorkerNotEmptyWithSinceParametersSuccessDummy(sinceId: "djhbs8aud")

        sut = CatalogListSceneInteractor(presenter: presnterSpy)

        sut.worker = workerDummy

        sut.fetchCatalogList()

        XCTAssertEqual(presnterSpy.list.count, 1)
    }


}

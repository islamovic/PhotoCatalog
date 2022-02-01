//
//  CreatePhotoCatalogWebServiceTests.swift
//  PhotoCatalogTests
//
//  Created by Islam on 01/02/2022.
//

import XCTest
@testable import PhotoCatalog

class CreatePhotoCatalogWebServiceTests: XCTestCase {

    var sut: CreatePhotoCatalogWebService!

    override func setUp() {

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSeession = URLSession(configuration: config)

        let createPhotoCatalogRouter = CreatePhotoCatalogRouter()
        let networkManager = NetworkManager(session: urlSeession)
        sut = CreatePhotoCatalogWebService(createPhotoCatalog: createPhotoCatalogRouter, networkManager: networkManager)
    }

    override func tearDown() {

        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }

    func testCreatePhotoCatalogWebService_WhenGivenSucessfullResponse_ReturnSucess() {

        let mockModelData = loadCatalogListResponseMock("CreatePhotoCatalogResponseMock")
        MockURLProtocol.stubResponseData = try? JSONEncoder().encode(mockModelData)

        let expectaion = self.expectation(description: "Create a new photo cattalog success expectation")

        sut.createPhoto { result in

            switch result {
            case .success(let photo):
                XCTAssertEqual(photo.identifier, "6194de58670be", "The response should be the same id in the mock model data")
            case .failure:
                XCTFail()
            }
            expectaion.fulfill()
        }

        self.wait(for: [expectaion], timeout: 5)
    }

    func testCreatePhotoCatalogWebService_WhenGivenSuccessfullResponse_ReturnFailure() {

        let mockModelData = loadCatalogListResponseMock("CreatePhotoCatalogWrongResponseMock")
        MockURLProtocol.stubResponseData = try? JSONEncoder().encode(mockModelData)

        let expectation = self.expectation(description: "Create Catalog web service Response wrong Expectation")

        sut.createPhoto { response in

            switch response {
            case .success: break
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.decoding)
            }
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
    }

    func testCatalogListWebService_WhenURLRequestFail_ReturnError() {

        let expectation = self.expectation(description: "A failed Request expeectation")
        MockURLProtocol.error = NetworkError.failedRequest

        sut.createPhoto { response in

            switch response {
            case .success: break
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.failedRequest)
            }
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 2)
    }
}

private extension CreatePhotoCatalogWebServiceTests {
    func loadCatalogListResponseMock(_ fileName: String) -> CatalogItem? {

        guard let currentBundle = Bundle.allBundles.filter({ $0.bundlePath.hasSuffix(".xctest") }).first else {
            return nil
        }
        guard let url = currentBundle.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        guard let items = try? JSONDecoder().decode(CatalogItem.self, from: data) else {
            return nil
        }
        return items
    }
}

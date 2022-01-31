//
//  PhotosCatalogListWebServiceTests.swift
//  PhotoCatalogTests
//
//  Created by Islam on 31/01/2022.
//

import XCTest
@testable import PhotoCatalog

class PhotosCatalogListWebServiceTests: XCTestCase {

    var sut: CatalogListWebService!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)

        let catalogRouter = CatalogListRouter()
        let networkManager = NetworkManager(session: urlSession)
        sut = CatalogListWebService(catalogRouter: catalogRouter, networkManager: networkManager)
    }

    override func tearDown() {

        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }

    func testCatalogListWebService_WhenGivenSucessfullResponse_ReturnSucceess() {

        let mockModelData = loadCatalogListResponseMock("CatalogListResponseMock")
        MockURLProtocol.stubResponseData = try? JSONEncoder().encode(mockModelData)

        let expectation = self.expectation(description: "Catalog Web Service Response success Expectation")

        sut.fetch { response in

            switch response {
            case .success(let catalog):
                XCTAssertEqual(catalog.count, 3, "The response expeected to get the same number of mockede objects as in CatalogListResponseMock file")
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
    }

    func testCatalogListWebService_WhenGivenSuccessfullResponse_ReturnFailure() {

        let mockModelData = loadCatalogListResponseMock("CatalogListWorngResponseMock")
        MockURLProtocol.stubResponseData = try? JSONEncoder().encode(mockModelData)

        let expectation = self.expectation(description: "Catalog web service Response wrong Expectation")

        sut.fetch { response in

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

        sut.fetch { response in

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

private extension PhotosCatalogListWebServiceTests {
    func loadCatalogListResponseMock(_ fileName: String) -> [CatalogItem]? {

        guard let currentBundle = Bundle.allBundles.filter({ $0.bundlePath.hasSuffix(".xctest") }).first else {
            return nil
        }
        guard let url = currentBundle.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        guard let items = try? JSONDecoder().decode([CatalogItem].self, from: data) else {
            return nil
        }
        return items
    }
}

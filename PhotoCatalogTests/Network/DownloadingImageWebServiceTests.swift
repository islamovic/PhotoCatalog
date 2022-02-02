//
//  DownloadingImageWebServiceTests.swift
//  PhotoCatalogTests
//
//  Created by Islam on 03/02/2022.
//

import XCTest
@testable import PhotoCatalog

class DownloadingImageWebServiceTests: XCTestCase {

    var sut: DownloadingImageWebService!

    override func setUp() {

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSeession = URLSession(configuration: config)

        let networkManager = NetworkManager(session: urlSeession)
        sut = DownloadingImageWebService(networkManager: networkManager)
    }

    override func tearDown() {

        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }

    func testDownloadImageWebService_whenGivenSucessfullResponse_returnSuccess() {

        let mockImageData = loadImageData("Siena")
        let imageUrl = "https://via.placeholder.com/512x512?text=recent%20testing"
        MockURLProtocol.stubResponseData = mockImageData

        let expectaion = self.expectation(description: "Download a new photo successfully")

        sut.downloadImage(from: imageUrl) { result in
            switch result {
            case .success(let photo):
                if photo == nil {
                    XCTAssert(false, "Downloading Data not working.")
                } else {
                    XCTAssert(true, "Downloading Data is done successfully")
                }
            case .failure:
                XCTFail()
            }
            expectaion.fulfill()
        }

        self.wait(for: [expectaion], timeout: 5)
    }

    func testDownloadImageWebService_whenGivenSucessfullResponse_returnFailure() {

        let mockImageData = loadImageData("SienaImage")
        let imageUrl = "https://via.placeholder.com/512x512?text=recent%20testing"
        MockURLProtocol.stubResponseData = mockImageData

        let expectaion = self.expectation(description: "Download a new photo successfully")

        sut.downloadImage(from: imageUrl) { result in
            switch result {
            case .success(let photo):
                if photo == nil {
                    XCTAssert(true, "Downloading Data not working.")
                } else {
                    XCTAssert(false, "Downloading Data is done successfully")
                }
            case .failure:
                XCTFail()
            }
            expectaion.fulfill()
        }

        self.wait(for: [expectaion], timeout: 5)
    }

    func testDownloadImageWebService_WhenURLRequestFail_ReturnError() {

        let expectation = self.expectation(description: "A failed Request expeectation")
        let imageUrl = "https://via.placeholder.com/512x512?text=recent%20testing"
        MockURLProtocol.error = NetworkError.failedRequest

        sut.downloadImage(from: imageUrl) { response in

            switch response {
            case .success: break
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.failedRequest)
            }
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 2)
    }

    func testDownloadImageWebService_WhenGivenSuccessfullResponse_ReturnFailure() {

        let mockModelData = loadImageData("CreatePhotoCatalogWrongResponseMock")
        let imageUrl = "https://via.placeholder.com/512x512?text=recent%20testing"
        MockURLProtocol.stubResponseData = try? JSONEncoder().encode(mockModelData)

        let expectation = self.expectation(description: "Create Catalog web service Response wrong Expectation")

        sut.downloadImage(from: imageUrl) { response in

            switch response {
            case .success: break
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.decoding)
            }
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
    }
}

private extension DownloadingImageWebServiceTests {

    func loadImageData(_ imageName: String) -> Data? {

        guard let currentBundle = Bundle.allBundles.filter({ $0.bundlePath.hasSuffix(".xctest") }).first else {
            return nil
        }
        guard let url = currentBundle.url(forResource: imageName, withExtension: "jpg") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }
}

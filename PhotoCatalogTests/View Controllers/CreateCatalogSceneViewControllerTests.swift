//
//  CreateCatalogSceneViewControllerTests.swift
//  PhotoCatalogTests
//
//  Created by Islam on 03/02/2022.
//

import XCTest
@testable import PhotoCatalog

class CreateCatalogSceneViewControllerTests: XCTestCase {

    var sut: CreateCatalogViewController!

    override func setUp() {
        sut = CreateCatalogViewController()
    }

    override func tearDown() {
        sut = nil
    }

    func testCreateCatalog_GivenSuccussfullResponse() {

        let presenter = CreateCatalogScenePresenter(displayView: sut)

        let interactor = CreateCatalogSceneInteractor(presenter: presenter)

        sut.interactor = interactor

        sut.interactor.validateUserInput("recent testing", textDescription: "text", confidence: 0.7)

        XCTAssertEqual(sut.interactor.imageUrl, "https://via.placeholder.com/512x512?text=recent%20testing")
    }
}

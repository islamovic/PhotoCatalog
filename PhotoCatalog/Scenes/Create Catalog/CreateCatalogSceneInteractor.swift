//
//  CreateCatalogSceneInteractor.swift
//  PhotoCatalog
//
//  Created by Islam on 02/02/2022.
//

import Foundation

protocol CreateCatalogSceneDataStore: AnyObject {

    var imageUrl: String { get set }

    var textDescription: String { get set }

    var confidence: Float { get set }
}

protocol CreateCatalogSceneBusinessLogic: AnyObject {

    func validateUserInput(_ imageText: String?, textDescription: String?, confidence: Float)

    func createCatalogPhoto()
}

class CreateCatalogSceneInteractor: CreateCatalogSceneBusinessLogic, CreateCatalogSceneDataStore {

    // MARK: - Stored Properties
    let presenter: CreateCatalogScenePresentaionLogic?

    var imageUrl: String = ""

    var textDescription: String = ""

    var confidence: Float = 0

    let worker: CreateCatalogWorker

    // MARK: - Initializers
    required init(presenter: CreateCatalogScenePresentaionLogic) {
        self.presenter = presenter
        worker = CreateCatalogWorker()
    }
}

extension CreateCatalogSceneInteractor {

    func validateUserInput(_ imageText: String?, textDescription: String?, confidence: Float) {

        var url: String = "https://via.placeholder.com/512x512"
        if let imageText = imageText {
            url.append(contentsOf: "?text=\(imageText)")
            url = url.replacingOccurrences(of: " ", with: "%20")
        }
        self.imageUrl = url
        self.textDescription = textDescription ?? ""
        self.confidence = confidence
    }

    func createCatalogPhoto() {

        worker.createCatalog(imageURL: self.imageUrl,
                             textDescription: self.textDescription,
                             confidence: self.confidence) { result in
            switch result {
            case .success:
                self.presenter?.presentCreateCatalogPhotoSuccess()
            case .failure:
                self.presenter?.presentCreateCatalogPhotoFailure()
            }
        }
    }
}

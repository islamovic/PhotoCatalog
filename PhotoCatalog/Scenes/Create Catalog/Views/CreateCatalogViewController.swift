//
//  CreateCatalogViewController.swift
//  PhotoCatalog
//
//  Created by Islam on 02/02/2022.
//

import UIKit

protocol CreateCatalogSceneDisplayView: AnyObject {
    func displayViewCreateCatalogPhotoSuccess()
    func displayViewCreateCatalogPhotoFailure()
}

class CreateCatalogViewController: UIViewController {

    @IBOutlet private var textImageTextField: UITextField!
    @IBOutlet private var textDescriptionTextField: UITextField!
    @IBOutlet private var confidenceSlider: UISlider!
    @IBOutlet private var confidenceValueLabel: UILabel!
    @IBOutlet private var creationActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private var statusLabel: UILabel!

    var interactor: CreateCatalogSceneInteractor!
    var dataStore: CreateCatalogSceneDataStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @IBAction func createImageButtonTapped(_ sender: UIButton) {

        self.startLoading()
        self.statusLabel.isHidden = true
        self.interactor.validateUserInput(textImageTextField.text,
                                          textDescription: textDescriptionTextField.text,
                                          confidence: confidenceValueLabel.text?.floatValue ?? 0)
        self.interactor.createCatalogPhoto()
    }
    
    @IBAction func silderValueDidChanged(_ sender: UISlider) {
        self.confidenceValueLabel.text = String(format: "%.1f", sender.value)
    }
}

extension CreateCatalogViewController: CreateCatalogSceneDisplayView {

    func displayViewCreateCatalogPhotoSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.stopLoading()
            self?.showSuccessMessage()
        }
    }

    func displayViewCreateCatalogPhotoFailure() {
        DispatchQueue.main.async { [weak self] in
            self?.stopLoading()
            self?.showFailureMessage()
        }
    }
}

private extension CreateCatalogViewController {

    func setupUI() {
        self.creationActivityIndicator.isHidden = true
        self.statusLabel.isHidden = true
    }

    func startLoading() {
        self.creationActivityIndicator.isHidden = false
        self.creationActivityIndicator.startAnimating()
    }

    func stopLoading() {
        self.creationActivityIndicator.isHidden = true
        self.creationActivityIndicator.stopAnimating()
    }

    func showSuccessMessage() {
        self.statusLabel.isHidden = false
        self.statusLabel.text = "Image Created Successfully"
        self.statusLabel.textColor = .green
    }

    func showFailureMessage() {
        self.statusLabel.isHidden = false
        self.statusLabel.text = "Image not created brcause of an error, please try again shortly"
        self.statusLabel.textColor = .red
    }
}

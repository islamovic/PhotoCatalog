//
//  CatalogPhotoDetailsViewController.swift
//  PhotoCatalog
//
//  Created by Islam on 02/02/2022.
//

import UIKit

class CatalogPhotoDetailsViewController: UIViewController {

    @IBOutlet private var imageTextLabel: UILabel!
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var imageURLLabel: UILabel!
    @IBOutlet private var imageConfidenceLabel: UILabel!
    @IBOutlet private var identifierLabel: UILabel!

    var catalogItem: CatalogItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
}

private extension CatalogPhotoDetailsViewController {

    func updateUI() {

        self.imageTextLabel.text = self.catalogItem.text
        self.photoImageView.setImage(from: self.catalogItem.image)
        self.imageURLLabel.text = self.catalogItem.image
        self.imageConfidenceLabel.text = String(self.catalogItem.confidence)
        self.identifierLabel.text = self.catalogItem.identifier
    }
}

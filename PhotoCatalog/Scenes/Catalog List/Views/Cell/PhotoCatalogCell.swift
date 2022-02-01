//
//  PhotoCatalogCell.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import UIKit

class PhotoCatalogCell: UICollectionViewCell {

    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var catalogTextLabel: UILabel!
    @IBOutlet private var catalogConfidenceLabel: UILabel!
    @IBOutlet private var catalodIdentifierLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.photoImageView.layer.cornerRadius = 8
    }

    func configureCell(catalogItem: CatalogItem) {

        self.photoImageView.setImage(from: catalogItem.image)
        self.catalogTextLabel.text = catalogItem.text
        self.catalogConfidenceLabel.text = "\(catalogItem.confidence)"
        self.catalodIdentifierLabel.text = catalogItem.identifier
    }
}

//
//  PhotoCatalogCell.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import UIKit

class PhotoCatalogCell: UITableViewCell {

    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var itemTextLabel: UILabel!
    @IBOutlet private var confidenceLabel: UILabel!
    @IBOutlet private var identifierLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(photoCatalog: CatalogItem) {

        self.itemTextLabel.text = photoCatalog.text
        self.confidenceLabel.text = "\(photoCatalog.confidence)"
        self.identifierLabel.text = photoCatalog.identifier
    }
}

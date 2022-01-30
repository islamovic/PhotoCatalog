//
//  CatalogItem.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

struct CatalogItem: Decodable {
    let identifier: String
    let text: String
    let confidence: Float
    let image: String

    enum CodingKeys: String, CodingKey {
        case identifier = "_id"
        case text
        case confidence
        case image
    }
}

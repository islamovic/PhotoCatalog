//
//  SceneConfigurator.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation
import UIKit

protocol SceneConfigurator {
    associatedtype Parameter
    func configure(parameter: Parameter?) -> UIViewController
}

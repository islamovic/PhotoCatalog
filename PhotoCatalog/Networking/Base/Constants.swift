//
//  Constants.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import Foundation

public enum Constants {

    public enum Server { }
    public enum Client { }
}

extension Constants.Server {
    public static var baseUrl: String {
        let constant = Constant(fileName: "Constants")
        return constant.baseURL
    }
}

extension Constants.Client {
    public static var token: String {
        let constant = Constant(fileName: "Constants")
        return constant.token
    }
}

class Constant {

    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    var constants: [String: String]? {
        guard let path = Bundle.main.path(forResource: self.fileName, ofType: "plist") else {
            return [:]
        }
        let url = URL(fileURLWithPath: path)
        guard let constantData = try? Data(contentsOf: url) else {
            return [:]
        }
        guard let plistContent = try? PropertyListSerialization.propertyList(from: constantData,
                                                                             options: .mutableContainers,
                                                                             format: nil) as? [String: String] else {
            return nil
        }
        return plistContent
    }

    var baseURL: String {
        guard let constants = constants else {
            return ""
        }
        return constants["BaseURL"] ?? ""
    }

    var token: String {
        guard let constants = constants else {
            return ""
        }
        return constants["Token"] ?? ""
    }
}

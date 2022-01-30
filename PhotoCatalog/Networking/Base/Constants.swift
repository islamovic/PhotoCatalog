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
        return "https://marlove.net/e/mock/v1/items"
    }
}

extension Constants.Client {
    public static var token: String {
        return "38c9495a7045f0dccebe550baa3d0d07"
    }
}

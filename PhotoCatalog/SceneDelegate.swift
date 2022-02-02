//
//  SceneDelegate.swift
//  PhotoCatalog
//
//  Created by Islam on 30/01/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.windowScene = scene as? UIWindowScene
        let catalogListViewController = CatalogListSceneConfigurator()
        let viewController = catalogListViewController.configure()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

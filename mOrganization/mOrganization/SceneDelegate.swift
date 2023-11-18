//
//  SceneDelegate.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        let coordinator = GlobalCoordinator(self.window)
        coordinator.start()
    }

}

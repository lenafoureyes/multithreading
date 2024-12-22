//
//  ProfileCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.12.2024.
//

import UIKit

class ProfileCoordinator: ProfileBaseCoordinator {

    var parentCoordinator: MainBaseCoordinator?

    lazy var rootViewController: UIViewController = UINavigationController()

    func start() -> UIViewController {
        let loginViewController = LogInViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        self.rootViewController = navigationController

        return self.rootViewController
    }

    
}

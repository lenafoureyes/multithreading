//
//  FeedCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.12.2024.
//

import UIKit


class FeedCoordinator: FeedBaseCoordinator {

    var rootViewController: UIViewController

    var parentCoordinator: MainBaseCoordinator?

    init() {
        self.rootViewController = UINavigationController()
    }

    func start() -> UIViewController {
        let feedViewController = FeedViewController()
        feedViewController.navigationItem.largeTitleDisplayMode = .always
        (rootViewController as? UINavigationController)?.setViewControllers([feedViewController], animated: false)
        return rootViewController
    }

}

//
//  MainCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 13.12.2024.
//

import UIKit

enum AppFlow {
    case profile
    case feed
}

class MainCoordinator: MainBaseCoordinator {
    
    var parentCoordinator: MainBaseCoordinator?
    
    lazy var profileCoordinator: ProfileBaseCoordinator = ProfileCoordinator()
    lazy var feedCoordinator: FeedBaseCoordinator = FeedCoordinator()
    
    lazy var rootViewController: UIViewController = UITabBarController()
    
    func start() -> UIViewController {
        let profileViewController = profileCoordinator.start()
        profileCoordinator.parentCoordinator = self
        profileViewController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(
                systemName: "doc.richtext"
            ),
            tag: 0
        )
        
        let feedViewController = feedCoordinator.start()
        feedCoordinator.parentCoordinator = self
        feedViewController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(
                systemName: "person.circle"
            ),
            tag: 1
        )
        
        (rootViewController as? UITabBarController)?.viewControllers =
            [profileViewController,feedViewController]
        
        return rootViewController
    }
    
    func moveTo(flow: AppFlow) {
        switch flow {
        case .profile:
            (rootViewController as? UITabBarController)?.selectedIndex = 0
        case .feed:
            (rootViewController as? UITabBarController)?.selectedIndex = 0
        }
    }
    
    func resetToRoot() -> Self {
        profileCoordinator.resetToRoot()
        moveTo(flow: .profile)
        return self
    }
}

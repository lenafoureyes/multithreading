//
//  MainCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 13.12.2024.
//

import UIKit

class MainCoordinator: MainBaseCoordinator {
    
    var parentCoordinator: MainBaseCoordinator?
    var profileCoordinator: ProfileBaseCoordinator
    var feedCoordinator: FeedBaseCoordinator
    var favoritesCoordinator: FavoritesBaseCoordinator
    var rootViewController: UIViewController
    
    init() {
        self.profileCoordinator = ProfileCoordinator()
        self.feedCoordinator = FeedCoordinator()
        self.favoritesCoordinator = FavoritesCoordinator()
        self.rootViewController = UITabBarController()
    }
    
    func start() -> UIViewController {
        let profileViewController = profileCoordinator.start()
        profileViewController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.circle"),
            tag: 0
        )
        
        let feedViewController = feedCoordinator.start()
        feedViewController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "doc.richtext"),
            tag: 1
        )
        
        let favoritesViewController = favoritesCoordinator.start()
        favoritesViewController.tabBarItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(systemName: "heart.fill"),
            tag: 2
        )
        
        (rootViewController as? UITabBarController)?.viewControllers = [
            profileViewController,
            feedViewController,
            favoritesViewController
        ]
        return rootViewController
    }
    
    func moveTo(flow: AppFlow) {
        switch flow {
        case .profile:
            (rootViewController as? UITabBarController)?.selectedIndex = 0
        case .feed:
            (rootViewController as? UITabBarController)?.selectedIndex = 1
        case .favorites:
            (rootViewController as? UITabBarController)?.selectedIndex = 2
        }
    }
    
    func resetToRoot() -> Self {
        profileCoordinator.resetToRoot()
        moveTo(flow: .profile)
        return self
    }
}

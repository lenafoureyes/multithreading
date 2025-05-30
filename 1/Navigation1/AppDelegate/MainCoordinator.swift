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
    var rootViewController: UIViewController

    init() {
        self.profileCoordinator = ProfileCoordinator()
        self.feedCoordinator = FeedCoordinator()
        self.rootViewController = UITabBarController()
    }

    func start() -> UIViewController {
        let profileViewController = profileCoordinator.start()
        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab.profile", comment: "Profile tab title") ,
            image: UIImage(systemName: "person.circle"),
            tag: 0
        )

        let feedViewController = feedCoordinator.start()
        feedViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab.feed", comment: "Feed tab title"),
            image: UIImage(systemName: "doc.richtext"),
            tag: 1
        )

        (rootViewController as? UITabBarController)?.viewControllers = [profileViewController, feedViewController]
        return rootViewController
    }

    func moveTo(flow: AppFlow) {
        switch flow {
        case .profile:
            (rootViewController as? UITabBarController)?.selectedIndex = 0
        case .feed:
            (rootViewController as? UITabBarController)?.selectedIndex = 1
        }
    }

    func resetToRoot() -> Self {
        profileCoordinator.resetToRoot()
        moveTo(flow: .profile)
        return self
    }
}

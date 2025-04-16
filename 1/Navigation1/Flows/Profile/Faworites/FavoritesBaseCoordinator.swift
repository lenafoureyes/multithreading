//
//  FavoritesBaseCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.04.2025.
//
import UIKit
import StorageService

protocol FavoritesBaseCoordinator: Coordinator {
    func showPostDetail(post: Post)
}

class FavoritesCoordinator: FavoritesBaseCoordinator {
    var parentCoordinator: MainBaseCoordinator?
    var rootViewController: UIViewController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() -> UIViewController {
        let favoritesViewController = FavoritesViewController()
        (rootViewController as? UINavigationController)?.pushViewController(favoritesViewController, animated: false)
        return rootViewController
    }
    
    func showPostDetail(post: Post) {
        let postDetailVC = PostDetailViewController(post: post)
        (rootViewController as? UINavigationController)?.pushViewController(postDetailVC, animated: true)
    }
}

//
//  MainTabBarController.swift
//  Quote
//
//  Created by Елена Хайрова on 15.04.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let downloadVC = DownloadQuoteViewController()
        downloadVC.tabBarItem = UITabBarItem(title: "Загрузка", image: UIImage(systemName: "arrow.down.circle"), tag: 0)
        
        let listVC = QuoteListViewController()
        listVC.tabBarItem = UITabBarItem(title: "Все цитаты", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let categoriesVC = CategoriesViewController()
        categoriesVC.tabBarItem = UITabBarItem(title: "Категории", image: UIImage(systemName: "folder"), tag: 2)
        
        viewControllers = [
            UINavigationController(rootViewController: downloadVC),
            UINavigationController(rootViewController: listVC),
            UINavigationController(rootViewController: categoriesVC)
        ]
    }
}

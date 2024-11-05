//
//  SceneDelegate.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        
        let feedNavigationController = UINavigationController(rootViewController: FeedViewController())
        feedNavigationController.title = "Лента"
        
        let loginFactory = MyLoginFactory()
        let loginViewController = LogInViewController()
        loginViewController.loginDelegate = loginFactory.makeLoginInspector() // Устанавливаем делегата
        let profileNavigationController = UINavigationController(rootViewController: loginViewController)
        profileNavigationController.title = "Профиль"
        
        tabBarController.viewControllers = [profileNavigationController, feedNavigationController]
        
        feedNavigationController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "doc.richtext"), tag: 0)
        profileNavigationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
        
        tabBarController.selectedIndex = 0
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Код для освобождения ресурсов
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Код для перезапуска задач
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Код для временных прерываний
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Код для отмены изменений при переходе в фон
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Код для сохранения данных и освобождения ресурсов
    }
}

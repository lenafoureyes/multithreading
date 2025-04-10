//
//  SceneDelegate.swift
//  Document
//
//  Created by Елена Хайрова on 09.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let authManager = AuthManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        showInitialScreen()
        window.makeKeyAndVisible()
    }
    
    func showInitialScreen() {
        if authManager.hasPassword {
            showPasswordInputScreen()
        } else {
            showPasswordCreationScreen()
        }
    }
    
    func showPasswordInputScreen() {
        let passwordVC = PasswordViewController(mode: .input)
        passwordVC.onSuccess = { [weak self] in
            self?.showMainApp()
        }
        window?.rootViewController = UINavigationController(rootViewController: passwordVC)
    }
    
    func showPasswordCreationScreen() {
        let passwordVC = PasswordViewController(mode: .create)
        passwordVC.onSuccess = { [weak self] in
            self?.showMainApp()
        }
        window?.rootViewController = UINavigationController(rootViewController: passwordVC)
    }
    
    func showMainApp() {
        let tabBarController = UITabBarController()
        
        // Files List
        let filesVC = ViewController()
        filesVC.fileManager = FileManagerModel()
        let filesNav = UINavigationController(rootViewController: filesVC)
        filesNav.tabBarItem = UITabBarItem(title: "Файлы", image: UIImage(systemName: "folder"), tag: 0)
        
        // Settings
        let settingsVC = SettingsViewController()
        settingsVC.authManager = authManager
        settingsVC.onPasswordChange = { [weak self] in
            self?.showPasswordCreationScreen()
        }
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 1)
        
        tabBarController.viewControllers = [filesNav, settingsNav]
        window?.rootViewController = tabBarController
    }

}
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }





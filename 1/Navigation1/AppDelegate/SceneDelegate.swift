//
//  SceneDelegate.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        mainCoordinator = MainCoordinator()
        window?.rootViewController = mainCoordinator?.start()
        window?.makeKeyAndVisible()
        
        LocalNotificationsService.shared.registerForLatestUpdatesIfPossible()
        performRandomAPIRequest()
    }
    
    private func performRandomAPIRequest() {
        let randomConfig: AppConfiguration = {
            let randomId = Int.random(in: 1...10)
            switch Int.random(in: 0...2) {
            case 0: return .post(randomId)
            case 1: return .user(randomId)
            case 2: return .photo(randomId)
            default: return .post(1)
            }
        }()
        
        print("Selected API configuration: \(randomConfig)")
        NetworkService.request(for: randomConfig)
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

//
//  Dark:Light.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2025.
//

import UIKit

extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
    
    // Основные цвета приложения
    static let appBackground: UIColor = createColor(
        lightMode: .white,
        darkMode: .black
    )
    
    static let appText: UIColor = createColor(
        lightMode: .black,
        darkMode: .white
    )
    
    static let appSecondaryText: UIColor = createColor(
        lightMode: .darkGray,
        darkMode: .lightGray
    )
    
    static let appAccent: UIColor = createColor(
        lightMode: .systemBlue,
        darkMode: .systemTeal
    )
    
    static let appCellBackground: UIColor = createColor(
        lightMode: .systemGray6,
        darkMode: .systemGray5
    )
}

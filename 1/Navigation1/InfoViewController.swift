//
//  InfoViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class InfoViewController: UIViewController {
    lazy var button: CustomButton = {
        let button = CustomButton(title: "удалить",
                                  titleColor: .black,
                                  backgroundColor: .gray,
                                  frame: CGRect(x: 50, y: 250, width: 80, height: 50),
                                  cornerRadius: 25,
                                  useAutoLayout: true)
        button.action = { [weak self] in
            self?.buttonUpgrade()
        }
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        
        self.view.addSubview(button)
    }
    
    @objc func buttonUpgrade() {
        let alert = UIAlertController(title: "вы уверенны ?", message: "Are you sure?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            print("ok")
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
            print("ok!")
        }))
        self.present(alert, animated: true)
    }
}

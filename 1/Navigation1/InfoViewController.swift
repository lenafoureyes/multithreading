//
//  InfoViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class InfoViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRectMake(50, 250, 80, 50))
        button.backgroundColor = .gray
        button.layer.cornerRadius = 25
        button.setTitle("удалить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonUpgrade), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = true
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



//
//  InfoViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class InfoViewController: UIViewController {
    lazy var button: CustomButton = {
        let button = CustomButton(title: NSLocalizedString("delete.button.title", comment: "Delete button title"),
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
        let alert = UIAlertController(title: NSLocalizedString("alert.confirm.title", comment: "Confirmation title"),
                                     message: NSLocalizedString("alert.confirm.message", comment: "Confirmation message"),
                                     preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.yes", comment: "Yes button"), style: .default, handler: { action in
            print("ok")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.no", comment: "No button"), style: .cancel, handler: { action in
            print("ok!")
        }))
        self.present(alert, animated: true)
    }
}

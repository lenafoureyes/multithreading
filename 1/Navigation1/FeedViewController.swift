//
//  FeedViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class FeedViewController: UIViewController {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var button1: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 12
        button.setTitle("Пост 1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.cornerRadius = 12
        button.setTitle("Пост 2", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .gray
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.heightAnchor.constraint(equalToConstant: 50),
            button2.widthAnchor.constraint(equalToConstant: 200),
            button2.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    struct Post {
        var title: String
    }
    var post = Post(title: "Пост")
    
    @objc func buttonAction(_ sender: UIButton) {
        let postViewController = PostViewController()
        postViewController.post = Post(title: sender.currentTitle ?? "Пост")
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
}

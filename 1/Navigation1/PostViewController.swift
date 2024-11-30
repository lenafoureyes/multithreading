//
//  PostViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class PostViewController: UIViewController {
    
    let myButtom = UIBarButtonItem(barButtonSystemItem: .action, target: PostViewController.self, action: #selector(look))
    
    var post: FeedViewController.Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        
        if let post = post {
        title = post.title
        }
        post?.title = "Пост"
        
        let myButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(look))
        navigationItem.rightBarButtonItem = myButton


    }
    @objc func look() {
        let infoViewController = InfoViewController()
        self.navigationController?.present(infoViewController, animated: true)
    }

}

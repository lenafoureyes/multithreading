//
//  ProfileViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//
import StorageService
import UIKit

class ProfileViewController: UIViewController {
    
    var user: User?

    private let tableView = UITableView()
    private var headerView: ProfileHeaderView?
    private let overlayView = UIView()
    private let closeButton = UIButton()
    private var avatarImageView: UIImageView?
    
    override func viewDidLoad() {
     super.viewDidLoad()
        
        setupTableView()
        setupOverlayView()
        setupCloseButton()
        
        headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 400))
        headerView?.navigationController = self.navigationController
        tableView.tableHeaderView = headerView

        headerView?.avatarTapHandler = { [weak self] in
            self?.showAvatarDetail()
        }
        if let user = user {
            headerView?.nameLabel.text = user.fullName
            headerView?.descriptionLabel.text = user.status
            headerView?.avatarImageView.image = user.avatar }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if DEBUG
            tableView.backgroundColor = .red
        #else
            tableView.backgroundColor = .white
        #endif
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
    }

    private func setupOverlayView() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        overlayView.isHidden = true
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.alpha = 0.0
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func showAvatarDetail() {
        guard let headerView = headerView else { return }
        let avatarImageView = headerView.avatarImageView


        // Удаляем аватар из headerView и добавляем его в основной view
        avatarImageView.removeFromSuperview()
        view.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = true

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        UIView.animate(withDuration: 0.5, animations: {
            avatarImageView.frame = CGRect(x: 0, y: (screenHeight - screenWidth * (avatarImageView.frame.height / avatarImageView.frame.width)) / 2, width: screenWidth, height: screenWidth * (avatarImageView.frame.height / avatarImageView.frame.width))
            avatarImageView.layer.cornerRadius = 0

            self.overlayView.isHidden = false
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.closeButton.alpha = 1.0
            })
        }
    }

    @objc private func closeButtonTapped() {
        guard let headerView = headerView else { return }
        let avatarImageView = headerView.avatarImageView
        
        UIView.animate(withDuration: 0.3, animations: {
            // Hide close button
            self.closeButton.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                // Resize avatar back to original
                avatarImageView.frame = CGRect(x: 16, y: 16, width: 150, height: 150)
                avatarImageView.layer.cornerRadius = 75
                
                // Hide overlay view
                self.overlayView.isHidden = true
            })
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let avatarImageView = avatarImageView {
            let screenWidth = UIScreen.main.bounds.width
            avatarImageView.frame.size.width = screenWidth
            avatarImageView.frame.size.height = screenWidth * (avatarImageView.frame.height / avatarImageView.frame.width)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = headerView else { return }

        let offsetY = scrollView.contentOffset.y

        if offsetY > 0 {
            headerView.frame.origin.y = -offsetY
        } else {
            headerView.frame.origin.y = 0
        }
    }
}

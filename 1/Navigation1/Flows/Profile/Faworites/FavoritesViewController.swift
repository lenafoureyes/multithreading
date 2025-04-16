//
//  FavoritesViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.04.2025.
//

import UIKit
import CoreData
import StorageService

class FavoritesViewController: UIViewController {
    
    private var filteredPosts: [Post] = []
    private var isFiltered = false
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Избранное"
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                            style: .plain,
                            target: self,
                            action: #selector(showSearchAlert)),
            UIBarButtonItem(image: UIImage(systemName: "xmark"),
                            style: .plain,
                            target: self,
                            action: #selector(clearFilter))
        ]
    }
    
    // MARK: - CoreData Operations (Optimized with background context)
    
    private func loadPosts() {
        CoreDataManager.shared.fetchPosts { [weak self] posts in
            DispatchQueue.main.async {
                self?.filteredPosts = posts
                self?.tableView.reloadData()
            }
        }
    }
    
    private func deletePost(_ post: Post) {
        CoreDataManager.shared.deletePost(post) { [weak self] in
            self?.loadPosts()
        }
    }
    
    // MARK: - Filtering
    
    private func filterPosts(by author: String) {
        CoreDataManager.shared.fetchPosts { [weak self] posts in
            DispatchQueue.main.async {
                self?.filteredPosts = posts.filter { $0.author.lowercased().contains(author.lowercased()) }
                self?.isFiltered = true
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func showSearchAlert() {
        let alert = UIAlertController(title: "Поиск по автору",
                                    message: nil,
                                    preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Имя автора"
        }
        
        alert.addAction(UIAlertAction(title: "Применить", style: .default) { [weak self] _ in
            guard let author = alert.textFields?.first?.text, !author.isEmpty else { return }
            self?.filterPosts(by: author)
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func clearFilter() {
        isFiltered = false
        loadPosts()
    }
}

// MARK: - UITableViewDelegate & DataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.configure(with: filteredPosts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else { return }
            let post = self.filteredPosts[indexPath.row]
            self.deletePost(post)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = filteredPosts[indexPath.row]
        (parent?.parent as? FavoritesBaseCoordinator)?.showPostDetail(post: post)
    }
}

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
    
    private var fetchResultsController: NSFetchedResultsController<FavoritePost>!
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupFetchResultsController()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
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
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(clearAllFavorites)
        )
    }
    
    private func setupFetchResultsController(filter: String? = nil) {
        fetchResultsController = CoreDataManager.shared.createFetchResultsController(
            for: self,
            filter: filter
        )
        
        do {
            try fetchResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Failed to fetch: \(error)")
        }
    }
    
    @objc private func clearAllFavorites() {
        let alert = UIAlertController(
            title: "Очистить избранное",
            message: "Все сохраненные посты будут удалены",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.deleteAllPosts()
        })
        
        present(alert, animated: true)
    }
    
    private func deleteAllPosts() {
        CoreDataManager.shared.deleteAllPosts { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.showAlert(title: "Успешно", message: "Все посты удалены")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        let post = fetchResultsController.object(at: indexPath)
        cell.configure(with: post.toPost())
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else { return }
            let post = self.fetchResultsController.object(at: indexPath)
            CoreDataManager.shared.deletePost(post) { _ in
                completion(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = fetchResultsController.object(at: indexPath).toPost()
        (parent?.parent as? FavoritesBaseCoordinator)?.showPostDetail(post: post)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange anObject: Any,
                   at indexPath: IndexPath?,
                   for type: NSFetchedResultsChangeType,
                   newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                let post = fetchResultsController.object(at: indexPath)
                cell.configure(with: post.toPost())
            }
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("Unknown change type")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - UISearchResultsUpdating
extension FavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        setupFetchResultsController(filter: searchController.searchBar.text)
    }
}

// MARK: - FavoritePost Extension
extension FavoritePost {
    func toPost() -> Post {
        return Post(
            author: author ?? "",
            description: postDescription ?? "",
            image: imageName ?? "",
            likes: Int(likes),
            views: Int(views)
        )
    }
}

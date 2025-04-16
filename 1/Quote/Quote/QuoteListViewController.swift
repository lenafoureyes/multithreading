//
//  QuoteListViewController.swift
//  Quote
//
//  Created by Елена Хайрова on 15.04.2025.
//

import UIKit
import RealmSwift

class QuoteListViewController: UIViewController {
    private let realmService = RealmService.shared
    private var quotes: Results<Quote>!
    private var notificationToken: NotificationToken?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Все цитаты"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupData() {
        quotes = realmService.getAllQuotes()
        
        notificationToken = quotes.observe { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

extension QuoteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let quote = quotes[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = quote.text
        
        if let category = quote.category {
            cell.detailTextLabel?.text = "Категория: \(category)"
        } else {
            cell.detailTextLabel?.text = "Без категории"
        }
        
        return cell
    }
}

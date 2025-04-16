//
//  DownloadQuoteViewController.swift
//  Quote
//
//  Created by Елена Хайрова on 15.04.2025.
//

import UIKit

class DownloadQuoteViewController: UIViewController {
    private let service = ChuckNorrisService.shared
    private let realmService = RealmService.shared
    
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить цитату", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadButton.addTarget(self, action: #selector(downloadQuote), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Загрузка цитаты"
        
        let stackView = UIStackView(arrangedSubviews: [quoteLabel, downloadButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func downloadQuote() {
        service.fetchRandomQuote { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quoteResponse):
                    self?.quoteLabel.text = quoteResponse.value
                    self?.realmService.saveQuote(quoteResponse)
                    
                    let alert = UIAlertController(
                        title: "Успешно",
                        message: "Цитата сохранена",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                    
                case .failure(let error):
                    self?.quoteLabel.text = "Ошибка загрузки: \(error.localizedDescription)"
                }
            }
        }
    }
}

//
//  InfoViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//
import UIKit

class InfoViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
   
    private let orbitalPeriodLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return label
    }()
    
    private lazy var button: CustomButton = {
        let button = CustomButton(
            title: "удалить",
            titleColor: .black,
            backgroundColor: .gray,
            cornerRadius: 25,
            useAutoLayout: false
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.action = { [weak self] in
            self?.buttonUpgrade()
        }
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPost()
        fetchPlanetData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        buttonStackView.addArrangedSubview(button)
      
        view.addSubview(titleLabel)
        view.addSubview(buttonStackView)
        view.addSubview(orbitalPeriodLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            orbitalPeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orbitalPeriodLabel.topAnchor.constraint(equalTo: view.topAnchor , constant: 50),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            buttonStackView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func fetchPost() {
        let postId = Int.random(in: 1...100)
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(postId)")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let post = PostJSON(json: json) {
                    DispatchQueue.main.async {
                        self?.titleLabel.text = post.title
                    }
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    private func fetchPlanetData() {
        let url = URL(string: "https://swapi.dev/api/planets/1/")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let planet = try decoder.decode(Planet.self, from: data)
                
                DispatchQueue.main.async {
                    self?.orbitalPeriodLabel.text = "Орбитальный период Татуина: \(planet.orbitalPeriod) стандартных дней"
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    @objc private func buttonUpgrade() {
        let alert = UIAlertController(
            title: "Вы уверены?",
            message: "Are you sure?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
            print("Подтверждено")
        })
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel) { _ in
            print("Отменено")
        })
        
        present(alert, animated: true)
    }
}

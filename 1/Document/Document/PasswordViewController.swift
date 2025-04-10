//
//  PasswordViewController.swift
//  Document
//
//  Created by Елена Хайрова on 10.04.2025.
//

import UIKit

enum PasswordMode {
    case create
    case input
}

class PasswordViewController: UIViewController {
    private let authManager = AuthManager()
    private var mode: PasswordMode
    private var firstPassword: String?
    
    var onSuccess: (() -> Void)?
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите пароль"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(mode: PasswordMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Пароль"
        
        let stackView = UIStackView(arrangedSubviews: [passwordTextField, actionButton, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func updateUI() {
        switch mode {
        case .create:
            actionButton.setTitle("Создать пароль", for: .normal)
        case .input:
            actionButton.setTitle("Введите пароль", for: .normal)
        }
    }
    
    @objc private func handleButtonTap() {
        guard let password = passwordTextField.text, !password.isEmpty else {
            showError("Пароль не может быть пустым")
            return
        }
        
        switch mode {
        case .create:
            handlePasswordCreation(password)
        case .input:
            handlePasswordInput(password)
        }
    }
    
    private func handlePasswordCreation(_ password: String) {
        if firstPassword == nil {
            guard password.count >= 4 else {
                showError("Пароль должен содержать минимум 4 символа")
                return
            }
            
            firstPassword = password
            passwordTextField.text = ""
            passwordTextField.placeholder = "Повторите пароль"
            actionButton.setTitle("Повторите пароль", for: .normal)
        } else {
            if password == firstPassword {
                if authManager.savePassword(password) {
                    onSuccess?()
                } else {
                    showError("Не удалось сохранить пароль")
                    resetPasswordCreation()
                }
            } else {
                showError("Пароли не совпадают")
                resetPasswordCreation()
            }
        }
    }
    
    private func handlePasswordInput(_ password: String) {
        if authManager.validatePassword(password) {
            onSuccess?()
        } else {
            showError("Неверный пароль")
        }
    }
    
    private func resetPasswordCreation() {
        firstPassword = nil
        passwordTextField.text = ""
        passwordTextField.placeholder = "Введите пароль"
        actionButton.setTitle("Создать пароль", for: .normal)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

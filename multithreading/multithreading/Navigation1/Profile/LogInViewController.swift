//
//  LogInViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 25.07.2024.
//

import UIKit

class LogInViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let logoImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "logo")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    let emailTextField: UITextField = {
        let emailText = UITextField()
        emailText.placeholder = "Email or phone"
        emailText.textColor = .black
        emailText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        emailText.autocapitalizationType = .none
        emailText.keyboardType = UIKeyboardType.default
        emailText.returnKeyType = UIReturnKeyType.done
        emailText.isUserInteractionEnabled = true
        emailText.translatesAutoresizingMaskIntoConstraints = false
        return emailText
    }()
    
    let passwordTextField: UITextField = {
        let passwordText = UITextField()
        passwordText.placeholder = "Password"
        passwordText.textColor = .black
        passwordText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        passwordText.autocapitalizationType = .none
        passwordText.keyboardType = UIKeyboardType.default
        passwordText.returnKeyType = UIReturnKeyType.done
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        passwordText.isUserInteractionEnabled = true
        passwordText.isSecureTextEntry = true
        return passwordText
    }()
    
    let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let separatorView: UIView = {
        let separation = UIView()
        separation.backgroundColor = .lightGray
        separation.translatesAutoresizingMaskIntoConstraints = false
        return separation
    }()
    
    private lazy var logButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        
        if let blueImage = UIImage(named: "blue.png") {
            button.setBackgroundImage(blueImage, for: .normal)
        } else {
            print("Ошибка загрузки изображения 'blue.png'")
        }
        button.alpha = 1.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        button.addTarget(self, action: #selector(buttonDisabled(_:)), for: .touchDragExit)
        button.addTarget(self, action: #selector(logButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func logButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if email.isEmpty || password.isEmpty {
            print("Please enter both email and password")
        } else {
            let profileViewController = ProfileViewController()
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 1.0
        }
    }

    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.8
        }
    }

    @objc private func buttonDisabled(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.3
            sender.setTitleColor(.gray, for: .normal)
        }
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(inputStackView)
        contentView.addSubview(separatorView)
        contentView.addSubview(logButton)
        
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(tapGesture)
        
        setupConstraints()
        navigationController?.navigationBar.isHidden = true
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            inputStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            inputStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            inputStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            inputStackView.heightAnchor.constraint(equalToConstant: 100),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            separatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            logButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            logButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logButton.heightAnchor.constraint(equalToConstant: 50),
            logButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

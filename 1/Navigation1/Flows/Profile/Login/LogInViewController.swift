//
//  LogInViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 25.07.2024.
//

import UIKit

class LogInViewController: UIViewController {
    
    var loginDelegate: LoginViewControllerDelegate?
    private let factory = MyLoginFactory()
    private let authService = LocalAuthorizationService()
    
    private lazy var biometryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBiometryAuth), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
        emailText.placeholder = NSLocalizedString("email.phone", comment: "login email or phone")
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
        passwordText.placeholder = NSLocalizedString("password", comment: "login password")
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
    
    private var userService: UserService = {
        let avatarImage = UIImage(named: "cat") ?? UIImage()
        let user = User(login: "user123", fullName: "Meow Master", avatar: avatarImage, status: "mew")
        return CurrentUserService(user: user)
    }()
    
    private lazy var logButton: CustomButton = {
        let button = CustomButton(title: NSLocalizedString("button.login", comment: "button Log in"),
                                  titleColor: .white,
                                  cornerRadius: 10,
                                  useAutoLayout: false,
                                  font: .systemFont(ofSize: 18,weight: .semibold),
                                  masksToBounds: true)
        if let blueImage = UIImage(named: "blue.png") {
            button.setBackgroundImage(blueImage, for: .normal)
        } else {
            print("Ошибка загрузки изображения 'blue.png'")
        }
        
        button.alpha = 1.0
        button.action = { [weak self] in
            self?.logButtonTapped()
        }
        
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        button.addTarget(self, action: #selector(buttonDisabled(_:)), for: .touchDragExit)
        
        return button
    }()
    
    @objc private func logButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        activityIndicator.startAnimating()
        logButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            do {
                let success = try self.loginDelegate?.check(login: email, password: password) ?? false
                
                if success {
                    // Для тестового пользователя используем TestUserService
                    let testUserService = TestUserService()
                    if let user = testUserService.getUser(byLogin: email) {
                        let profileViewController = ProfileViewController()
                        profileViewController.user = user
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                    } else {
                        self.showAlert(message: NSLocalizedString("login.error.userNotFound", comment: "user not found"))
                    }
                }
            } catch let error as LoginError {
                self.showAlert(message: error.localizedDescription)
                if error == .tooManyAttempts || error == .accountLocked {
                    self.logButton.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                        self.logButton.isEnabled = true
                        Checker.shared.resetAttempts()
                    }
                }
            } catch {
                self.showAlert(message: NSLocalizedString("login.error.unknown", comment: "An unknown error occurred"))
            }
            
            self.activityIndicator.stopAnimating()
            self.logButton.isEnabled = true
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("login.error.title", comment: "eror"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("login.error.ok", comment: "ok"), style: .default))
        present(alert, animated: true)
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
        let factory = MyLoginFactory()
        loginDelegate = factory.makeLoginInspector()
        
        print("Navigation Controller: \(String(describing: self.navigationController))")
        
#if DEBUG
        userService = TestUserService()
#endif
        self.view.backgroundColor = .white
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(inputStackView)
        contentView.addSubview(separatorView)
        contentView.addSubview(logButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(biometryButton)
        
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupConstraints()
        configureBiometryButton()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureBiometryButton() {
        var configuration = UIButton.Configuration.filled()
        
        switch authService.availableBiometryType {
        case .faceID:
            configuration.image = UIImage(systemName: "faceid")
            configuration.title = " Войти с Face ID"
        case .touchID:
            configuration.image = UIImage(systemName: "touchid")
            configuration.title = " Войти с Touch ID"
        default:
            biometryButton.isHidden = true
            return
        }
        
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        
        biometryButton.configuration = configuration
        biometryButton.isHidden = false
    }
    
    @objc private func handleBiometryAuth() {
        authService.authorizeIfPossible { [weak self] success, error in
            if success {
                // Авторизация успешна - выполняем вход
                self?.performLoginWithBiometry()
            } else if let error = error {
                self?.showBiometryError(error)
            }
        }
    }
    
    private func performLoginWithBiometry() {
        // Здесь можно использовать тестовые учетные данные или хранить их в Keychain
        let testLogin = "testUser"
        let testPassword = "123"
        
        emailTextField.text = testLogin
        passwordTextField.text = testPassword
        
        // Имитируем нажатие кнопки входа
        logButtonTapped()
    }
    
    private func showBiometryError(_ error: AuthorizationError) {
        let alert = UIAlertController(
            title: "Ошибка биометрии",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        if case .biometryNotEnrolled = error {
            alert.addAction(UIAlertAction(
                title: "Настройки",
                style: .default,
                handler: { _ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            ))
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            
            biometryButton.topAnchor.constraint(equalTo: logButton.bottomAnchor, constant: 16),
            biometryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            biometryButton.widthAnchor.constraint(equalToConstant: 200),
            biometryButton.heightAnchor.constraint(equalToConstant: 44),
            biometryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: logButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: logButton.centerYAnchor)
        ])
    }
}

//
//  FeedViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class FeedViewController: UIViewController {

    var viewModel: FeedViewModel!
    var coordinator: FeedBaseCoordinator? // Добавлен координатор

    lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: "Проверить",
                                  titleColor: .white,
                                  backgroundColor: .brown,
                                  cornerRadius: 4,
                                  useAutoLayout: false)
        button.action = { [weak self] in
            self?.checkGuess()
        }
        return button
    }()

    var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите пароль"
        field.textColor = .black
        field.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        field.autocapitalizationType = .none
        field.keyboardType = .default
        field.returnKeyType = .done
        field.isUserInteractionEnabled = true
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    var resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var button1: CustomButton = {
        let button = CustomButton(title: "Пост 1",
                                  titleColor: .white,
                                  backgroundColor: .blue,
                                  cornerRadius: 12,
                                  useAutoLayout: false)
        button.action = { [weak self] in
            self?.buttonAction(button)
        }
        return button
    }()

    lazy var button2: CustomButton = {
        let button = CustomButton(title: "Пост 2",
                                  titleColor: .white,
                                  backgroundColor: .green,
                                  cornerRadius: 12,
                                  useAutoLayout: false)
        button.action = { [weak self] in
            self?.buttonAction(button)
        }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FeedViewModel(secretWord: "пароль")

        view.backgroundColor = .gray

        view.addSubview(textField)
        view.addSubview(checkGuessButton)
        view.addSubview(resultLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 40),

            checkGuessButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            checkGuessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkGuessButton.widthAnchor.constraint(equalToConstant: 200),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 50),

            resultLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 20),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.heightAnchor.constraint(equalToConstant: 50),
            button2.widthAnchor.constraint(equalToConstant: 200),
            button2.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    struct Post {
        var title: String
    }

    @objc func buttonAction(_ sender: UIButton) {
        let postViewController = PostViewController()
        postViewController.post = Post(title: sender.currentTitle ?? "Пост")
        self.navigationController?.pushViewController(postViewController, animated: true)
    }

    @objc func checkGuess() {
        guard let inputText = textField.text, !inputText.isEmpty else {
            resultLabel.text = "Введите слово!"
            resultLabel.textColor = .red
            return
        }

        viewModel.checkGuess(word: inputText)
        updateResultLabel()
    }

    func updateResultLabel() {
        resultLabel.text = viewModel.resultText
        resultLabel.textColor = viewModel.isResultCorrect ? .green : .red
    }
}

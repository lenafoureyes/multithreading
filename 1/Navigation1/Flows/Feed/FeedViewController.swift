//
//  FeedViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//
import UIKit
import AVFoundation

class FeedViewController: UIViewController {
    
    var player: AVAudioPlayer?
        var currentTrackIndex = 0
        let tracks = [
            ("vielleicht", "mp3"),
            ("chess", "mp3"),
            ("zima", "mp3"),
            ("aura", "mp3"),
            ("BREATH", "mp3")
        ]
    
    var viewModel: FeedViewModel!
    var coordinator: FeedBaseCoordinator?
    
    lazy var playPauseButton: CustomButton = {
        let button = CustomButton(title: NSLocalizedString("player.play", comment: "Play button title"),
                                 titleColor: .white,
                                 backgroundColor: .systemBlue,
                                 cornerRadius: 12,
                                 useAutoLayout: false)
        button.action = { [weak self] in
            self?.togglePlayPause()
        }
        return button
    }()
    
    lazy var stopButton: CustomButton = {
        let button = CustomButton(title: NSLocalizedString("player.stop", comment: "Stop button title"),
                                 titleColor: .white,
                                 backgroundColor: .systemRed,
                                 cornerRadius: 12,
                                 useAutoLayout: false)
        button.action = { [weak self] in
            self?.stopAudio()
        }
        return button
    }()
    
    lazy var nextButton: CustomButton = {
        let button = CustomButton(title: NSLocalizedString("player.next", comment: "Next button title"),
                                 titleColor: .white,
                                 backgroundColor: .systemGreen,
                                 cornerRadius: 12,
                                 useAutoLayout: false)
        button.action = { [weak self] in
            self?.playNextTrack()
        }
        return button
    }()
    
    lazy var prevButton: CustomButton = {
        let button = CustomButton(title:  NSLocalizedString("player.prev", comment: "Previous button title"),
                                 titleColor: .white,
                                 backgroundColor: .systemGreen,
                                 cornerRadius: 12,
                                 useAutoLayout: false)
        button.action = { [weak self] in
            self?.playPreviousTrack()
        }
        return button
    }()
    
    var trackNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var playerStack: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [prevButton, playPauseButton, stopButton, nextButton])
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
    
    lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: NSLocalizedString("guess.check", comment: "Check guess button title"),
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
        field.placeholder = NSLocalizedString("password.placeholder", comment: "Password field placeholder")
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
        let button = CustomButton(title: NSLocalizedString("post.button1", comment: "Post 1 button title"),
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
        let button = CustomButton(title: NSLocalizedString("post.button2", comment: "Post 2 button title"),
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
        
        setupAudioPlayer()
        setupUI()
        setupConstraints()
    }
    
    private func setupAudioPlayer() {
        guard currentTrackIndex >= 0 && currentTrackIndex < tracks.count else { return }
        let track = tracks[currentTrackIndex]
        
        guard let path = Bundle.main.path(forResource: track.0, ofType: track.1) else {
            print("Audio file not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.prepareToPlay()
            updateTrackInfo()
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    private func togglePlayPause() {
            guard let player = player else { return }
            
            if player.isPlaying {
                player.pause()
                playPauseButton.setTitle(NSLocalizedString("player.play", comment: "Play button title"), for: .normal)
                playPauseButton.backgroundColor = .systemBlue
            } else {
                player.play()
                playPauseButton.setTitle(NSLocalizedString("player.pause", comment: "Pause button title"), for: .normal)
                playPauseButton.backgroundColor = .systemOrange
            }
        }
    
    private func stopAudio() {
        player?.stop()
        player?.currentTime = 0
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.backgroundColor = .systemBlue
    }
    
    private func playNextTrack() {
        currentTrackIndex = (currentTrackIndex + 1) % tracks.count
        setupAudioPlayer()
        player?.play()
        playPauseButton.setTitle("Pause", for: .normal)
        playPauseButton.backgroundColor = .systemOrange
    }
    
    private func playPreviousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + tracks.count) % tracks.count
        setupAudioPlayer()
        player?.play()
        playPauseButton.setTitle("Pause", for: .normal)
        playPauseButton.backgroundColor = .systemOrange
    }
    
    private func updateTrackInfo() {
        trackNameLabel.text = tracks[currentTrackIndex].0
    }
    
    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(checkGuessButton)
        view.addSubview(resultLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        view.addSubview(playerStack)
        view.addSubview(trackNameLabel)
    }
    
    // MARK: - Constraints
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
            button2.heightAnchor.constraint(equalToConstant: 50),
            
            trackNameLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            trackNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackNameLabel.widthAnchor.constraint(equalToConstant: 300),
            
            playerStack.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 20),
            playerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerStack.widthAnchor.constraint(equalToConstant: 300),
            playerStack.heightAnchor.constraint(equalToConstant: 50),
            
            prevButton.widthAnchor.constraint(equalToConstant: 70),
            playPauseButton.widthAnchor.constraint(equalToConstant: 70),
            stopButton.widthAnchor.constraint(equalToConstant: 70),
            nextButton.widthAnchor.constraint(equalToConstant: 70)
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
        viewModel.checkGuess(word: textField.text ?? "")
        updateResultLabel()
    }
    
    func updateResultLabel() {
        resultLabel.text = viewModel.resultText
        resultLabel.textColor = viewModel.isResultCorrect ? .green : .red
    }
}

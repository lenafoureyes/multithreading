//
//  ProfileHeaderView.swift
//  Navigation1
//
//  Created by Елена Хайрова on 17.06.2024.
//

import UIKit

class ProfileHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cat")
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(white: 242.0/255.0, alpha: 1.0).cgColor
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.text = "Meow_Master"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        label.text = "mew"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Нажми меня", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectionView: UICollectionView!
    
    let photosLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var navigationController: UINavigationController?
    var avatarTapHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupViews()
        setupConstraints()
        addTapGestureToAvatar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        setupViews()
        setupConstraints()
        addTapGestureToAvatar()
    }
    
    private func addTapGestureToAvatar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func avatarTapped() {
        avatarTapHandler?()
        
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosTableViewCell.self, forCellWithReuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = true
        addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfItemsPerRow: CGFloat = 4
        let totalSpacing: CGFloat = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0 * (numberOfItemsPerRow - 1)
        let itemWidth = (screenWidth - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func setupViews() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(button)
        addSubview(photosLabel)
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 34),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 34),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            button.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            photosLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            photosLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 12),
            
            collectionView.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotosTableViewCell.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosTableViewCell.reuseIdentifier, for: indexPath) as! PhotosTableViewCell
        cell.configure(with: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photosViewController = PhotosViewController()
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    @objc func buttonPressed() {
        if let text = descriptionLabel.text {
            print(text)
        }
    }
}

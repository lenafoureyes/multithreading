//
//  ProfileHeaderView.swift
//  Navigation1
//
//  Created by Елена Хайрова on 17.06.2024.
//
import UIKit
import SnapKit

class ProfileHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cat")
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(white: 242.0/255.0, alpha: 1.0).cgColor
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.text = "Meow_Master"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        label.text = "mew"
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
        return button
    }()
    
    var collectionView: UICollectionView!
    
    let photosLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    weak var navigationController: UINavigationController?
    var avatarTapHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        setupViews()
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosTableViewCell.self, forCellWithReuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = true
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
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(34)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(18)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(34)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        photosLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(button.snp.bottom).offset(12)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(photosLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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

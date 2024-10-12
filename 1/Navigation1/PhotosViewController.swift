//
//  PhotosViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.08.2024.
//
import UIKit

class PhotosViewController: UIViewController {

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupTitleLabel()
        setupCollectionView()
    }

    private func configureView() {
        view.backgroundColor = .white
    }

    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "Photo Gallery"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCell")
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 72),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8 * 4
        let availableWidth = collectionView.frame.width - padding
        let itemWidth = availableWidth / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

extension PhotosViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCell
        cell.imageView.image = UIImage(named: "cat\(indexPath.item + 1)")
        return cell
    }
}

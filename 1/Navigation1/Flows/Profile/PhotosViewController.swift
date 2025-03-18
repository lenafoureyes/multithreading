//
//  PhotosViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.08.2024.
//
import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var images: [UIImage] = []  // Массив изображений
    private let imageProcessor = ImageProcessor()  // Экземпляр обработчика изображений
    private var selectedFilter: ColorFilter = .sepia(intensity: 1.0) // Выбранный фильтр

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupTitleLabel()
        setupCollectionView()
        
        loadImages() // Загрузка изображений
        applyFiltersWithDifferentQoS()  // Применяем фильтры с разными QoS
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

    private func loadImages() {
            // Пример загрузки изображений с именами cat1, cat2 и т.д.
            for index in 1...20 {
                if let image = UIImage(named: "cat\(index)") {
                    images.append(image)
                }
            }
            collectionView.reloadData()  // Перезагружаем данные коллекции, чтобы обновить отображение
        }
    
    private func applyFiltersWithDifferentQoS() {
        let qosValues: [QualityOfService] = [.userInteractive, .userInitiated, .default, .utility, .background]
        
        for qos in qosValues {
            processImages(qos: qos)
        }
    }
    
    private func processImages(qos: QualityOfService) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Вызов метода processImagesOnThread для обработки изображений
        imageProcessor.processImagesOnThread(sourceImages: images, filter: selectedFilter, qos: qos) { [weak self] processedImages in
            DispatchQueue.main.async {
                let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
                print("Время обработки с qos \(qos): \(elapsedTime) секунд")
                
                self?.images = processedImages.compactMap { $0.flatMap { UIImage(cgImage: $0) } }
                self?.collectionView.reloadData()  // Обновляем коллекцию после обработки
            }
        }
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
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}

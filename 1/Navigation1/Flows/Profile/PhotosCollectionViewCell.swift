//
//  PhotosCollectionViewCell.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.08.2024.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    // Image view for displaying images in the collection view
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill  // Для масштабирования изображения с сохранением пропорций
        imageView.clipsToBounds = true            // Обрезать изображение по краям ячейки
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Добавляем imageView в contentView ячейки
        contentView.addSubview(imageView)
        
        // Устанавливаем constraints для правильного позиционирования imageView в ячейке
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // Required initializer for using the cell in Interface Builder (if needed)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Метод для обновления изображения в ячейке
    func updateImage(_ image: UIImage) {
        imageView.image = image
    }
}

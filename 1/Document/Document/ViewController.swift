//
//  ViewController.swift
//  Document
//
//  Created by Елена Хайрова on 09.04.2025.
//

import UIKit

class ViewController: UITableViewController {
    var fileManager: FileManagerModel! {
        didSet {
            fileManager.loadImages()
        }
    }
    
    private let imagePicker = UIImagePickerController()
    private var isSortingEnabled: Bool {
        return UserDefaults.standard.bool(forKey: "sortingEnabled")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load called")
        setupUI()
        setupNotifications()
        view.backgroundColor = .white
        print("Loaded images count: \(fileManager.imageNames.count)")
    }
    
    private func setupUI() {
        title = "Документы"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Добавить фото",
            style: .plain,
            target: self,
            action: #selector(addPhotoTapped)
        )
        
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sortingSettingsChanged),
            name: .sortingSettingsChanged,
            object: nil
        )
    }
    
    @objc private func sortingSettingsChanged() {
        fileManager.loadImages()
        tableView.reloadData()
    }
    
    @objc private func addPhotoTapped() {
        present(imagePicker, animated: true)
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileManager.imageNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageName = fileManager.imageNames[indexPath.row]
        cell.configure(with: fileManager.getImage(named: imageName))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completion) in
            self?.fileManager.deleteImage(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            fileManager.saveImage(image)
            tableView.reloadData()
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - Custom Cell

class ImageCell: UITableViewCell {
    private let photoView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(photoView)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with image: UIImage?) {
        photoView.image = image
    }
}


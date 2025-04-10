//
//  FileManagerModel.swift
//  Document
//
//  Created by Елена Хайрова on 09.04.2025.
//

import UIKit

class FileManagerModel {
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var imageNames: [String] = []
    
    init() {
        loadImages()
    }
    
    func loadImages() {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory.path)
            imageNames = files.filter { $0.hasSuffix(".jpg") || $0.hasSuffix(".png") }
        } catch {
            print("Error loading images: \(error.localizedDescription)")
        }
    }
    
    func saveImage(_ image: UIImage) {
        let filename = "\(UUID().uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: fileURL)
                loadImages()
            } catch {
                print("Error saving image: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteImage(at index: Int) {
        let filename = imageNames[index]
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            imageNames.remove(at: index)
        } catch {
            print("Error deleting image: \(error.localizedDescription)")
        }
    }
    
    func getImage(named name: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent(name)
        return UIImage(contentsOfFile: fileURL.path)
    }
}

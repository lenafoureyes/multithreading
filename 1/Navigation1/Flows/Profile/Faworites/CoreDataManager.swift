//
//  CoreDataManager.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.04.2025.
//
import UIKit
import StorageService
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack (Optimized)
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        
        // Оптимизация: предварительная загрузка хранилища
        container.loadPersistentStores { [weak self] storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            // Оптимизация: настройка автоматического слияния изменений
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        
        return container
    }()
    
    // Основной контекст (UI)
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Фоновый контекст для операций записи
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - CRUD Operations
    
    func savePost(_ post: Post, completion: @escaping () -> Void) {
        backgroundContext.perform { [weak self] in
            let favoritePost = FavoritePost(context: self?.backgroundContext ?? NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType))
            favoritePost.author = post.author
            favoritePost.postDescription = post.description
            favoritePost.imageName = post.image
            favoritePost.likes = Int32(post.likes)
            favoritePost.views = Int32(post.views)
            favoritePost.createdAt = Date()
            
            do {
                try self?.backgroundContext.save()
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Failed to save post: \(error)")
            }
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        // Оптимизация: пакетное получение
        fetchRequest.fetchBatchSize = 20
        
        backgroundContext.perform {
            do {
                let favoritePosts = try self.backgroundContext.fetch(fetchRequest)
                let posts = favoritePosts.map {
                    Post(author: $0.author ?? "",
                         description: $0.postDescription ?? "",
                         image: $0.imageName ?? "",
                         likes: Int($0.likes),
                         views: Int($0.views))
                }
                DispatchQueue.main.async {
                    completion(posts)
                }
            } catch {
                print("Error fetching posts: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func deletePost(_ post: Post, completion: @escaping () -> Void) {
        backgroundContext.perform { [weak self] in
            let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "author == %@ AND postDescription == %@",
                                               post.author, post.description)
            
            do {
                let posts = try self?.backgroundContext.fetch(fetchRequest) ?? []
                posts.forEach { self?.backgroundContext.delete($0) }
                try self?.backgroundContext.save()
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error deleting post: \(error)")
            }
        }
    }
}

//
//  CoreDataManager.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.04.2025.
//
import UIKit
import CoreData
import StorageService

// MARK: - CoreDataManager
class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData: \(error)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    // MARK: - Post Operations
    
    func savePost(_ post: Post, completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let favoritePost = FavoritePost(context: context)
            favoritePost.author = post.author
            favoritePost.postDescription = post.description
            favoritePost.imageName = post.image
            favoritePost.likes = Int32(post.likes)
            favoritePost.views = Int32(post.views)
            favoritePost.createdAt = Date()
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Failed to save post: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func deletePost(_ post: FavoritePost, completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            context.delete(post)
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Failed to delete post: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func deleteAllPosts(completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoritePost.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Failed to delete all posts: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func createFetchResultsController(for delegate: NSFetchedResultsControllerDelegate,
                                    filter: String? = nil) -> NSFetchedResultsController<FavoritePost> {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        if let filter = filter, !filter.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "author CONTAINS[cd] %@", filter)
        }
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = delegate
        return controller
    }
}



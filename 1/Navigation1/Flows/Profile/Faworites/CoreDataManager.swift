//
//  CoreDataManager.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.04.2025.
//

import CoreData
import UIKit
import StorageService

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Favorite Posts CRUD
    
    func savePost(_ post: Post) {
        let favoritePost = FavoritePost(context: context)
        favoritePost.author = post.author
        favoritePost.postDescription = post.description
        favoritePost.imageName = post.image
        favoritePost.likes = Int32(post.likes)
        favoritePost.views = Int32(post.views)
        favoritePost.createdAt = Date()
        
        saveContext()
    }
    
    func fetchPosts() -> [Post] {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let favoritePosts = try context.fetch(fetchRequest)
            return favoritePosts.map {
                Post(author: $0.author ?? "",
                     description: $0.postDescription ?? "",
                     image: $0.imageName ?? "",
                     likes: Int($0.likes),
                     views: Int($0.views))
            }
        } catch {
            print("Error fetching posts: \(error)")
            return []
        }
    }
    
    func deletePost(_ post: Post) {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author == %@ AND postDescription == %@", post.author, post.description)
        
        do {
            let posts = try context.fetch(fetchRequest)
            posts.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting post: \(error)")
        }
    }
}

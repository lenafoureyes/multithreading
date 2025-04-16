//
//  RealmService.swift
//  Quote
//
//  Created by Елена Хайрова on 15.04.2025.
//

import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    private var realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func saveQuote(_ quoteResponse: QuoteResponse) {
        if realm.object(ofType: Quote.self, forPrimaryKey: quoteResponse.id) != nil {
            return
        }
        
        let quote = Quote()
        quote.id = quoteResponse.id
        quote.text = quoteResponse.value
        quote.dateAdded = Date()
        
        if let categoryName = quoteResponse.categories.first {
            quote.category = categoryName
    
            let category: Category
            if let existingCategory = realm.object(ofType: Category.self, forPrimaryKey: categoryName) {
                category = existingCategory
            } else {
                category = Category()
                category.name = categoryName
            }
            
            try! realm.write {
                category.quotes.append(quote)
                realm.add(category, update: .modified)
            }
        } else {
            try! realm.write {
                realm.add(quote)
            }
        }
    }
    
    func getAllQuotes() -> Results<Quote> {
        return realm.objects(Quote.self).sorted(byKeyPath: "dateAdded", ascending: false)
    }
    
    func getAllCategories() -> Results<Category> {
        return realm.objects(Category.self)
    }
    
    func getQuotes(for category: String) -> Results<Quote> {
        return realm.objects(Quote.self).filter("category == %@", category).sorted(byKeyPath: "dateAdded", ascending: false)
    }
}

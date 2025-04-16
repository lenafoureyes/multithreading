//
//  Quote.swift
//  Quote
//
//  Created by Елена Хайрова on 15.04.2025.
//

import RealmSwift

class Quote: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var text: String
    @Persisted var dateAdded: Date
    @Persisted var category: String?
}

class Category: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var quotes: List<Quote>
}

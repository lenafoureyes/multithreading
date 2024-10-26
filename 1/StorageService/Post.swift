//
//  Post.swift
//  Navigation1
//
//  Created by Елена Хайрова on 02.08.2024.
//

import Foundation

public struct Post {
    public let author: String
    public let description: String
    public let image: String
    public let likes: Int
    public let views: Int
}

public let posts: [Post] = [
    Post(author: "Meow_Master", description: "Walking my man", image: "selfie1", likes: 10, views: 100),
    Post(author: "Meow_Master", description: "with the brothers in the area", image: "selfie2", likes: 20, views: 200),
    Post(author: "Meow_Master", description: "With my girlfriend", image: "selfie3", likes: 30, views: 300),
    Post(author: "Meow_Master", description: "My brother and I are going to drink", image: "selfie4", likes: 40, views: 400)
]

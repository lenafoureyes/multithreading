//
//  Post.swift
//  Navigation1
//
//  Created by Елена Хайрова on 05.04.2025.
//

//{
//    "userId": 1,
//    "id": 1,
//    "title": "delectus aut autem",
//    "completed": false
//  },

import Foundation

struct PostJSON {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
    
    init?(json: [String: Any]) {
        guard let userId = json["userId"] as? Int,
              let id = json["id"] as? Int,
              let title = json["title"] as? String,
              let completed = json["completed"] as? Bool else {
            return nil
        }
        
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }
}

struct Planet: Decodable {
    let name : String
    let rotationPeriod : String
    let orbitalPeriod : String
    let diameter : String
    let climate : String
    let terrain : String
    
    private enum CodingKeys : String , CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter
        case climate
        case terrain
    }
}

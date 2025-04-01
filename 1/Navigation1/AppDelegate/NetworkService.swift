//
//  NetworkService.swift
//  Navigation1
//
//  Created by Елена Хайрова on 01.04.2025.
//

import Foundation

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        let urlString: String
        
        switch configuration {
                case .post(let id):
                    urlString = "https://jsonplaceholder.typicode.com/posts/\(id)"
                case .user(let id):
                    urlString = "https://jsonplaceholder.typicode.com/users/\(id)"
                case .photo(let id):
                    urlString = "https://jsonplaceholder.typicode.com/photos/\(id)"
                }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                print("Headers: \(httpResponse.allHeaderFields)")
            }
            
            if let data = data, let stringData = String(data: data, encoding: .utf8) {
                print("Response data: \(stringData)")
            }
        }
        
        task.resume()
    }
}

enum AppConfiguration {
    case post(Int)
    case user(Int)
    case photo(Int)     
}

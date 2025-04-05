//
//  NetworkService.swift
//  Navigation1
//
//  Created by Елена Хайрова on 01.04.2025.
//
import Foundation

enum AppConfiguration {
    case post(Int)
    case user(Int)
    case photo(Int)
    
    var url: URL? {
        let baseUrl: String
        let id: Int
        
        switch self {
        case .post(let postId):
            baseUrl = "https://jsonplaceholder.typicode.com/posts"
            id = postId
        case .user(let userId):
            baseUrl = "https://jsonplaceholder.typicode.com/users"
            id = userId
        case .photo(let photoId):
            baseUrl = "https://jsonplaceholder.typicode.com/photos"
            id = photoId
        }
        
        return URL(string: "\(baseUrl)/\(id)")
    }
}

struct NetworkService {
    static func request(url: URL?) async throws -> (data: Data, response: HTTPURLResponse) {
        guard let url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Убираем избыточную проверку, так как data(from:) гарантированно возвращает HTTPURLResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, httpResponse)
    }
    
    static func fetch<T: Decodable>(url: URL?) async throws -> T {
        let (data, response) = try await request(url: url)
        
        guard (200...299).contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // Совместимость со старым кодом
    static func request(for configuration: AppConfiguration) {
        Task {
            do {
                guard let url = configuration.url else {
                    print("Invalid URL for configuration: \(configuration)")
                    return
                }
                
                let (data, response) = try await request(url: url)
                
                // Убираем избыточное приведение типа
                print("Status code: \(response.statusCode)")
                print("Headers: \(response.allHeaderFields)")
                
                if let stringData = String(data: data, encoding: .utf8) {
                    print("Response data: \(stringData)")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

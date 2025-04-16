//
//  ChuckNorrisService.swift
//  Quote
//
//  Created by Елена Хайрова on 15.04.2025.
//

import Alamofire

class ChuckNorrisService {
    static let shared = ChuckNorrisService()
    
    private let baseUrl = "https://api.chucknorris.io/jokes"
    
    func fetchRandomQuote(completion: @escaping (Result<QuoteResponse, Error>) -> Void) {
        AF.request("\(baseUrl)/random").responseDecodable(of: QuoteResponse.self) { response in
            switch response.result {
            case .success(let quoteResponse):
                completion(.success(quoteResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct QuoteResponse: Codable {
    let id: String
    let value: String
    let categories: [String]
}

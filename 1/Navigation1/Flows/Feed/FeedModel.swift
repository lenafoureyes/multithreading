//
//  FeedModel.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.11.2024.
//
import Foundation

enum FeedError: Error {
    case emptyInput
    case incorrectGuess
}

class FeedModel {
    private let secretWord: String
    
    init(secretWord: String) {
        self.secretWord = secretWord
    }
    
    func check(word: String) -> Result<Bool, FeedError> {
        guard !word.isEmpty else {
            return .failure(.emptyInput)
        }
        return word == secretWord ? .success(true) : .failure(.incorrectGuess)
    }
}

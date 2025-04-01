//
//  FeedViewModel.swift
//  Navigation1
//
//  Created by Елена Хайрова on 30.11.2024.
//
import Foundation

class FeedViewModel {
    private let feedModel: FeedModel
    var resultText: String = ""
    var isResultCorrect: Bool = false
    
    init(secretWord: String) {
        self.feedModel = FeedModel(secretWord: secretWord)
    }
    
    func checkGuess(word: String) {
        let result = feedModel.check(word: word)
        
        switch result {
        case .success:
            isResultCorrect = true
            resultText = "Верно!"
        case .failure(let error):
            isResultCorrect = false
            switch error {
            case .emptyInput:
                resultText = "Введите слово!"
            case .incorrectGuess:
                resultText = "Неверно!"
            }
        }
    }
}

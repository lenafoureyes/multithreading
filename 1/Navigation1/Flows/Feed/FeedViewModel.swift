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
            resultText = NSLocalizedString("guess.result.correct", comment: "Correct guess message")
        case .failure(let error):
            isResultCorrect = false
            switch error {
            case .emptyInput:
                resultText = NSLocalizedString("guess.error.empty", comment: "Empty input error")
            case .incorrectGuess:
                resultText = NSLocalizedString("guess.result.incorrect", comment: "Incorrect guess message")
            }
        }
    }
}

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
        isResultCorrect = feedModel.check(word: word)
        resultText = isResultCorrect ? "Верно!" : "Неверно!"
    }
}

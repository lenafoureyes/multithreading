//
//  FeedModel.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.11.2024.
//
import Foundation

class FeedModel {
    private let secretWord: String

    init(secretWord: String) {
        self.secretWord = secretWord
    }

    func check(word: String) {
        let isCorrect = word == secretWord
        NotificationCenter.default.post(name: Notification.Name("GuessResult"), object: nil, userInfo: ["isCorrect": isCorrect])
    }
}

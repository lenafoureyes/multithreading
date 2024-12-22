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

    func check(word: String) -> Bool {
        return word == secretWord 
    }
}

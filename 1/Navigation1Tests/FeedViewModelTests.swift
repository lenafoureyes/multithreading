//
//  FeedViewModelTests.swift
//  Navigation1Tests
//
//  Created by Елена Хайрова on 30.05.2025.
//

import Foundation
import XCTest
@testable import Navigation1

final class FeedViewModelTests: XCTestCase {
    
    // Тест проверки правильного слова
    func testCheckGuessWithCorrectWord() {
        // Подготовка
        let secretWord = "секрет"
        let viewModel = FeedViewModel(secretWord: secretWord)
        
        // Действие
        viewModel.checkGuess(word: secretWord)
        
        // Проверка
        XCTAssertTrue(viewModel.isResultCorrect)
        XCTAssertEqual(viewModel.resultText, "Верно!")
    }
    
    // Тест проверки неправильного слова
    func testCheckGuessWithIncorrectWord() {
        // Подготовка
        let secretWord = "секрет"
        let viewModel = FeedViewModel(secretWord: secretWord)
        
        // Действие
        viewModel.checkGuess(word: "неверно")
        
        // Проверка
        XCTAssertFalse(viewModel.isResultCorrect)
        XCTAssertEqual(viewModel.resultText, "Неверно!")
    }
    
    // Тест проверки пустого ввода
    func testCheckGuessWithEmptyInput() {
        // Подготовка
        let secretWord = "секрет"
        let viewModel = FeedViewModel(secretWord: secretWord)
        
        // Действие
        viewModel.checkGuess(word: "")
        
        // Проверка
        XCTAssertFalse(viewModel.isResultCorrect)
        XCTAssertEqual(viewModel.resultText, "Введите слово")
    }
}

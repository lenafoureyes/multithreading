//
//  LoginViewModelTests.swift
//  Navigation1Tests
//
//  Created by Елена Хайрова on 30.05.2025.
//

import XCTest
@testable import Navigation1 

class LoginViewModelTests: XCTestCase {
    
    var checker: Checker!
    var loginInspector: LoginInspector!
    
    override func setUp() {
        super.setUp()
        checker = Checker.shared
        checker.resetAttempts() // Сбрасываем счетчик попыток перед каждым тестом
        loginInspector = LoginInspector()
    }
    
    override func tearDown() {
        checker = nil
        loginInspector = nil
        super.tearDown()
    }
    
    // Тест 1: Проверка успешного входа с правильными учетными данными
    func testSuccessfulLogin() {
        XCTAssertNoThrow(try {
            let result = try loginInspector.check(login: "testUser", password: "123")
            XCTAssertTrue(result, "Вход должен быть успешным при правильных учетных данных")
        }(), "Не должно быть ошибки при правильных учетных данных")
    }
    
    // Тест 2: Проверка ошибки при пустых полях
    func testEmptyCredentials() {
        XCTAssertThrowsError(try loginInspector.check(login: "", password: ""), "Должна быть ошибка при пустых полях") { error in
            XCTAssertEqual(error as? LoginError, LoginError.emptyCredentials, "Ожидалась ошибка emptyCredentials")
        }
    }
    
    // Тест 3: Проверка блокировки после слишком большого количества попыток
    func testTooManyAttempts() {
        // Первые две попытки с неправильным паролем
        XCTAssertThrowsError(try loginInspector.check(login: "testUser", password: "wrong1"))
        XCTAssertThrowsError(try loginInspector.check(login: "testUser", password: "wrong2"))
        
        // Третья попытка должна заблокировать вход
        XCTAssertThrowsError(try loginInspector.check(login: "testUser", password: "wrong3"), "Должна быть ошибка tooManyAttempts") { error in
            XCTAssertEqual(error as? LoginError, LoginError.tooManyAttempts, "Ожидалась ошибка tooManyAttempts")
        }
        
        // Проверяем, что после блокировки даже правильные данные не работают
        XCTAssertThrowsError(try loginInspector.check(login: "testUser", password: "123"), "После блокировки должна быть ошибка tooManyAttempts")
    }
    
    // Тест 4: Проверка неверного логина
    func testInvalidLogin() {
        XCTAssertThrowsError(try loginInspector.check(login: "wrongUser", password: "123"), "Должна быть ошибка invalidLogin") { error in
            XCTAssertEqual(error as? LoginError, LoginError.invalidLogin, "Ожидалась ошибка invalidLogin")
        }
    }
    
    // Тест 5: Проверка неверного пароля
    func testWrongPassword() {
        XCTAssertThrowsError(try loginInspector.check(login: "testUser", password: "wrong"), "Должна быть ошибка wrongPassword") { error in
            XCTAssertEqual(error as? LoginError, LoginError.wrongPassword, "Ожидалась ошибка wrongPassword")
        }
    }
}

//
//  Checker.swift
//  Navigation1
//
//  Created by Елена Хайрова on 24.10.2024.
//
import UIKit

enum LoginError: Error {
    case emptyCredentials
    case invalidLogin
    case wrongPassword
    case credentialsMismatch
    case accountLocked
    case tooManyAttempts
    
    var localizedDescription: String {
        switch self {
        case .emptyCredentials:
            return NSLocalizedString("error.emptyCredentials", comment: "Please enter login and password")
        case .invalidLogin:
            return NSLocalizedString("error.invalidLogin", comment: "Invalid login")
        case .wrongPassword:
            return NSLocalizedString("error.wrongPassword", comment: "Wrong password")
        case .credentialsMismatch:
            return NSLocalizedString("error.credentialsMismatch", comment: "Login and password don't match")
        case .accountLocked:
            return NSLocalizedString("error.accountLocked", comment: "Account temporarily locked")
        case .tooManyAttempts:
            return NSLocalizedString("error.tooManyAttempts", comment: "Too many attempts. Try again later")
        }
    }
}
class Checker {
    static let shared = Checker()
    
    private let validLogin: String = "testUser"
    private let validPassword: String = "123"
    private var attemptCount = 0
    private let maxAttempts = 3
    private init() {}
    
    func check(login: String, password: String) throws -> Bool {
        // Проверка на пустые поля
        guard !login.isEmpty, !password.isEmpty else {
            throw LoginError.emptyCredentials
        }
        // Проверка количества попыток
        attemptCount += 1
        if attemptCount >= maxAttempts {
            throw LoginError.tooManyAttempts
        }
        
        // Проверка логина
        guard login == validLogin else {
            throw LoginError.invalidLogin
        }
        
        // Проверка пароля
        guard password == validPassword else {
            throw LoginError.wrongPassword
        }
        // Сброс счетчика при успешном входе
        attemptCount = 0
        return true
    }
    
    func resetAttempts() {
        attemptCount = 0
    }
}

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) throws -> Bool
}
class LoginInspector: LoginViewControllerDelegate {
    private let checker = Checker.shared
    
    func check(login: String, password: String) throws -> Bool {
        return try checker.check(login: login, password: password)
    }
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate {
        return LoginInspector()
    }
}

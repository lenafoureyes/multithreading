//
//  Checker.swift
//  Navigation1
//
//  Created by Елена Хайрова on 24.10.2024.
//

class Checker {
    static let shared = Checker()
    
    private let login: String = "user123"
    private let password: String = "password123"
    private init() {}
    func check(login: String, password: String) -> Bool {
        return self.login == login && self.password == password }
}

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}


struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
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

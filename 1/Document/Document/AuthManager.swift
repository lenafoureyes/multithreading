//
//  AuthManager.swift
//  Document
//
//  Created by Елена Хайрова on 10.04.2025.
//
import Foundation
import KeychainAccess

class AuthManager {
    private let keychain = Keychain(service: "com.yourapp.password")
    private let passwordKey = "appPassword"
    
    var hasPassword: Bool {
        return getPassword() != nil
    }
    
    func savePassword(_ password: String) -> Bool {
        do {
            try keychain.set(password, key: passwordKey)
            return true
        } catch {
            print("Error saving password: \(error)")
            return false
        }
    }
    
    func getPassword() -> String? {
        do {
            return try keychain.get(passwordKey)
        } catch {
            print("Error getting password: \(error)")
            return nil
        }
    }
    
    func validatePassword(_ password: String) -> Bool {
        return getPassword() == password
    }
    
    func deletePassword() -> Bool {
        do {
            try keychain.remove(passwordKey)
            return true
        } catch {
            print("Error deleting password: \(error)")
            return false
        }
    }
}

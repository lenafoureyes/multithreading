//
//  PasswordGenerator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 21.03.2025.
//

import UIKit

class PasswordBruteForce {
    private let allowedCharacters: [String] = String().printable.map { String($0) }
    
    func bruteForce(passwordToUnlock: String, completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var password: String = ""
            while password != passwordToUnlock {
                password = self.generateBruteForce(password, fromArray: self.allowedCharacters)
            }
            DispatchQueue.main.async {
                completion(password)
            }
        }
    }
    
    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string
        
        if str.isEmpty {
            str.append(characterAt(index: 0, array))
        } else {
            let lastCharIndex = str.index(str.startIndex, offsetBy: str.count - 1)
            let lastChar = str[lastCharIndex]
            let nextChar = characterAt(index: (indexOf(character: lastChar, array) + 1) % array.count, array)
            
            str.replaceSubrange(lastCharIndex...lastCharIndex, with: String(nextChar))
            
            if indexOf(character: nextChar, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(nextChar)
            }
        }
        
        return str
    }
    
    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? 0
    }
    
    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index]) : Character("")
    }
}

extension String {
    var digits: String { return "0123456789" }
    var lowercase: String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase: String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters: String { return lowercase + uppercase }
    var printable: String { return digits + letters + punctuation }
}

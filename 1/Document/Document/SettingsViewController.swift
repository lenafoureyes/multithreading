//
//  SettingsViewController.swift
//  Document
//
//  Created by Елена Хайрова on 10.04.2025.
//

import UIKit

class SettingsViewController: UITableViewController {
    private let userDefaults = UserDefaults.standard
    private let sortingKey = "sortingEnabled"
    
    var authManager: AuthManager!
    var onPasswordChange: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Сортировка по алфавиту"
            let switchView = UISwitch()
            switchView.isOn = userDefaults.bool(forKey: sortingKey)
            switchView.addTarget(self, action: #selector(sortingSwitchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
        case 1:
            cell.textLabel?.text = "Изменить пароль"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            onPasswordChange?()
        }
    }
    
    @objc private func sortingSwitchChanged(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: sortingKey)
        NotificationCenter.default.post(name: .sortingSettingsChanged, object: nil)
    }
}

extension Notification.Name {
    static let sortingSettingsChanged = Notification.Name("sortingSettingsChanged")
}

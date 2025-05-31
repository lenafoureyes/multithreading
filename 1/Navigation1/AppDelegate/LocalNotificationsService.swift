import UserNotifications

class LocalNotificationsService: NSObject {
    static let shared = LocalNotificationsService()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func registerForLatestUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound, .badge, .alert]) { [weak self] granted, error in
            if granted {
                print("Notification permission granted")
                self?.scheduleDailyNotification()
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Посмотрите последние обновления"
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "dailyUpdatesNotification",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка при планировании ежедневного уведомления: \(error.localizedDescription)")
            } else {
                print("Ежедневное уведомление успешно запланировано на 19:00")
            }
        }
    }
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

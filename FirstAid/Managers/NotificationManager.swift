//
//  NotificationManager.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 28.10.2021.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var settings: UNNotificationSettings?
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
            self.fetchNotificationSettings()
            completion(granted)
        }
    }
    
    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent() 
        
        content.title = "First Aid"
        content.body = "Самое время повторить изученный материал!(нет)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var date = DateComponents()
        date.hour = Calendar.current.component(.hour, from: Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "1",
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
            
        }
        
    }
    
    func removeNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
    
}

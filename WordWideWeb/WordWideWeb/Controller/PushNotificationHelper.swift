//
//  PushNotificationHelper.swift
//  WordWideWeb
//
//  Created by 신지연 on 2024/05/21.
//

import Foundation
import UserNotifications

class PushNotificationHelper {
    
    static let shared = PushNotificationHelper()
    
    private init() { }
    
    func pushNotification(test: String, time: DateComponents, identifier: String) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "시험 볼 시간입니다!"
        notificationContent.body = "\(test)시험을 위해 이동하세요"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
}

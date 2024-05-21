//
//  AppDelegate.swift
//  WorldWordWeb
//
//  Created by 신지연 on 2024/05/14.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        if Auth.auth().currentUser != nil {
            // 이미 로그인된 사용자가 있을 경우 Firestore에서 최신 사용자 정보 업데이트
            Task {
                do {
                    try await AuthenticationManager.shared.updateUserProfileFromFirestore()
                } catch {
                    print("Failed to update user profile from Firestore: \(error)")
                }
            }
        }
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 포그라운드 상태(앱 실행 중)일때 알림을 받으면 해야할 행동을 정의
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        completionHandler([.list, .banner])
    }
    
    // 사용자가 알림 메시지를 클릭 했을 경우에 실행
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("move to testVC")
        let wordbook = fetchWordbooks(id: response.notification.request.identifier)
 
        NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["wordbook": wordbook])
        completionHandler()
    }
    
    func fetchWordbooks(id: String) -> [Wordbook] {
        var wordbooks: [Wordbook]?
        Task {
            do {
                print(id)
                wordbooks = try await FirestoreManager.shared.fetchWordbooks(for: id)
                print("wordbooks\(wordbooks)")
            } catch {
                print("Error fetching wordbooks: \(error.localizedDescription)")
            }
        }
        guard let result = wordbooks else {return []}
        return result
    }
}


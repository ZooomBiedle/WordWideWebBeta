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


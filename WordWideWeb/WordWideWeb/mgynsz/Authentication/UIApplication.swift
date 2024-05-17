//
//  UIApplication.swift
//  WordWideWeb
//
//  Created by David Jang on 5/17/24.
//

import Foundation
import UIKit

extension UIApplication {

    static private func rootViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if #available(iOS 15.0, *) {
                return windowScene.keyWindow?.rootViewController
            } else {
                return windowScene.windows.first { $0.isKeyWindow }?.rootViewController
            }
        }
        return nil
    }
    
    @MainActor static func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? rootViewController()
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}



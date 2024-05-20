//
//  TabBarController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/17/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
//import SDWebImage

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setDefaultTabBarImages()
    }

    func setTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
        // 탭바 높이 설정
        let customHeight: CGFloat = 78
        var tabFrame = tabBar.frame
        tabFrame.size.height = customHeight
        tabFrame.origin.y = view.frame.size.height - customHeight
        tabBar.frame = tabFrame
    }
    
    func setDefaultTabBarImages() {
        updateTabBarImages()
    }
    
    fileprivate func updateTabBarImages() {
        viewControllers = [
            createNavController(for: MyPageVC(), image: UIImage(systemName: "house.circle.fill")!),
            createNavController(for: PlayingListVC(), image: UIImage(systemName: "magnifyingglass.circle")!),
            createNavController(for: DictionaryVC(), image: UIImage(systemName: "plus.circle")!),
            createNavController(for: InvitingVC(), image: UIImage(systemName: "envelope.circle")!),
            createNavController(for: MyInfoVC(), image: UIImage(systemName: "person.crop.circle")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = UIColor(named: "bgColor")
        navController.tabBarItem.image = image.withRenderingMode(.alwaysOriginal) // 이미지 크기 유지
        navController.interactivePopGestureRecognizer?.delegate = nil // 스와이프 제스처 enable true
        return navController
    }
}

//extension UIImage {
//    func resizeImage(to size: CGSize) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: size))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//}

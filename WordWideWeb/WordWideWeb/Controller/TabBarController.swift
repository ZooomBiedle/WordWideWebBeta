//
//  TabBarController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/17/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBar()
        setAttribute()
    }

    func setTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.tintColor = UIColor(named: "pointColor")
        tabBar.backgroundColor = .white
    }
    
    func setAttribute() {
        viewControllers = [
            createNavController(for: MyPageVC(), image: UIImage(systemName: "house")!),
            createNavController(for: PlayingListVC(), image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: DictionaryVC(), image: UIImage(systemName: "plus.app")!),
            createNavController(for: InvitingVC(), image: UIImage(systemName: "envelope")!),
            createNavController(for: MyInfoVC(), image: UIImage(systemName: "person.crop.circle")!) // 프로필사진 불러와야..
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, image: UIImage) -> UIViewController {
            
            let navController = UINavigationController(rootViewController:  rootViewController)
            navController.navigationBar.isTranslucent = false
            navController.navigationBar.backgroundColor = UIColor(named: "bgColor")
            navController.tabBarItem.image = image
            navController.interactivePopGestureRecognizer?.delegate = nil // 스와이프 제스처 enable true
            return navController
        }
}

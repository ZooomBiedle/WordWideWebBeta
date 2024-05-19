//
//  TabBarController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/17/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setAttribute()
    }

    func setTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .white
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
    
    func setAttribute() {
        // 기본 이미지 설정
        let defaultProfileImage = UIImage(systemName: "person.circle")
        
        // Firestore에서 사용자 프로필 이미지 가져오기
        if let user = Auth.auth().currentUser {
            let userRef = Firestore.firestore().collection("users").document(user.uid)
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let photoURLString = document.data()?["photoURL"] as? String, let photoURL = URL(string: photoURLString) {
                        // 비동기로 이미지를 불러와서 설정
                        SDWebImageManager.shared.loadImage(with: photoURL, options: [], progress: nil) { image, _, _, _, _, _ in
                            let profileImage = image?.resizeImage(to: CGSize(width: 30, height: 30)) ?? defaultProfileImage
                            // 이미지를 설정한 후에 탭 바를 업데이트
                            DispatchQueue.main.async {
                                self.updateTabBarImages(profileImage: profileImage)
                            }
                        }
                    } else {
                        // photoURL이 없을 경우 기본 이미지
                        self.updateTabBarImages(profileImage: defaultProfileImage)
                    }
                } else {
                    // 문서가 없을 경우 기본 이미지
                    self.updateTabBarImages(profileImage: defaultProfileImage)
                }
            }
        } else {
            // 이미지 없으면 기본 이미지
            updateTabBarImages(profileImage: defaultProfileImage)
        }
    }
    
    fileprivate func updateTabBarImages(profileImage: UIImage?) {
        let defaultImage = UIImage(systemName: "person.crop.circle")!
        viewControllers = [
            createNavController(for: MyPageVC(), image: UIImage(systemName: "house.circle.fill")!),
            createNavController(for: PlayingListVC(), image: UIImage(systemName: "magnifyingglass.circle")!),
            createNavController(for: SearchFriendsVC(), image: UIImage(systemName: "plus.circle")!),
            createNavController(for: InvitingVC(), image: UIImage(systemName: "envelope.circle")!),
            createNavController(for: MyInfoVC(), image: profileImage ?? defaultImage) // 프로필 사진
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

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

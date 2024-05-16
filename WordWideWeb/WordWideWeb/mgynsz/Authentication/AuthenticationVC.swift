//
//  AuthenticationVC.swift
//  WordWideWeb
//
//  Created by David Jang on 5/14/24.
//

import UIKit
import SnapKit
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import AuthenticationServices

class AuthenticationVC: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up with Email", for: .normal)
        return button
    }()
    
    private let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setImage(UIImage(named: "GoogleIcon"), for: .normal) // 구글 로고 이미지 추가 필요
        button.imageView?.contentMode = .scaleAspectFit
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        return button
    }()
    
    private let appleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Apple", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupNotificationObservers()

        
        // 앱 시작 시 로그인 상태 확인
        if UserDefaults.standard.isLoggedIn && UserDefaults.standard.isAutoLoginEnabled {
            navigateToMainViewController()
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        // 뷰가 다시 표시될 때 필요한 작업
//        setupViews()
//    }
    
    private func setupViews() {
//        view.subviews.forEach { $0.removeFromSuperview() }
        
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(googleSignInButton)
        view.addSubview(appleSignInButton)
        
        signInButton.snp.makeConstraints { make in
            make.center.equalTo(view).offset(-20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.center.equalTo(view).offset(20)
        }
        
        googleSignInButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(32)
            make.centerX.equalTo(view)
            make.width.equalTo(240) // 버튼 너비 조정
            make.height.equalTo(44) // 버튼 높이 조정
        }
        
        appleSignInButton.snp.makeConstraints { make in
            make.top.equalTo(googleSignInButton.snp.bottom).offset(16)
            make.centerX.equalTo(view)
            make.width.equalTo(240)
            make.height.equalTo(44)
        }
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
        appleSignInButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)

    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLogout), name: .userDidLogout, object: nil)
    }
    
    @objc private func signInTapped() {
        let signInVC = SignInVC()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @objc private func signUpTapped() {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func googleSignInTapped() {
        Task {
            do {
                let signInResult = try await SignInGoogleHelper().signIn(viewController: self)
                print("Google Sign-In successful: \(signInResult)")
                try await authenticateWithFirebase(using: signInResult)
                UserDefaults.standard.isLoggedIn = true // 로그인 상태 저장
                navigateToMainViewController()
            } catch {
                print("Google Sign-In failed: \(error.localizedDescription)")
                // 여기서 로그인 실패 시의 동작을 추가합니다.
            }
        }
    }

    private func authenticateWithFirebase(using googleSignInResult: GoogleSignInResultModel) async throws {
        let credential = GoogleAuthProvider.credential(withIDToken: googleSignInResult.idToken, accessToken: googleSignInResult.accessToken)
        _ = try await Auth.auth().signIn(with: credential)
    }
    
    @objc private func appleSignInTapped() {
        Task {
            do {
                let helper = SignInWithAppleHelper()
                var signInResult: SignInWithAppleResult?

                for try await result in helper.startSignInWithAppleFlow(viewController: self) {
                    signInResult = result
                    break
                }
                
                guard let result = signInResult else {
                    print("Apple Sign-In failed: No result")
                    return
                }

                print("Apple Sign-In successful: \(result)")
                _ = try await AuthenticationManager.shared.signInWithApple(tokens: result) // 결과를 사용하지 않음을 명시적으로 표시
                UserDefaults.standard.isLoggedIn = true // 로그인 상태 저장
                UserDefaults.standard.appleIDToken = result.token
                UserDefaults.standard.appleNonce = result.nonce
                navigateToMainViewController()
            } catch {
                print("Apple Sign-In failed: \(error.localizedDescription)")
            }
        }
    }

    private func authenticateWithFirebase(using appleSignInResult: SignInWithAppleResult) async throws {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleSignInResult.token, rawNonce: appleSignInResult.nonce)
        _ = try await Auth.auth().signIn(with: credential)
    }

    
    func navigateToMainViewController() {
        let mainVC = ViewController()
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
    
    @objc private func handleUserLogout() {
        // 로그아웃 후 AuthenticationVC 다시 생성
        UserDefaults.standard.isLoggedIn = false
        UserDefaults.standard.isAutoLoginEnabled = false
        let authVC = AuthenticationVC()
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}

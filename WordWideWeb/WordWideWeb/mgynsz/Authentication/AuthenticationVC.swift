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
        button.setImage(UIImage(named: "google_logo"), for: .normal) // 구글 로고 이미지 추가 필요
        button.imageView?.contentMode = .scaleAspectFit
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(googleSignInButton)
        
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
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)

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
                let signInResult = try await SignInGoogleHelper().signIn()
                print("Google Sign-In successful: \(signInResult)")
                try await authenticateWithFirebase(using: signInResult)
                navigateToMainViewController()
            } catch {
                print("Google Sign-In failed: \(error.localizedDescription)")
                // 여기서 로그인 실패 시의 동작을 추가합니다.
            }
        }
    }
    
    private func authenticateWithFirebase(using signInResult: GoogleSignInResultModel) async throws {
        let credential = GoogleAuthProvider.credential(withIDToken: signInResult.idToken, accessToken: signInResult.accessToken)
        _ = try await Auth.auth().signIn(with: credential)
    }
    
    private func navigateToMainViewController() {
        let mainVC = ViewController() // 실제 ViewController 클래스명으로 교체 필요
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
}



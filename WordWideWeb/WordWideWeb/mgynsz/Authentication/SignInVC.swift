//
//  SignInVC.swift
//  WordWideWeb
//
//  Created by David Jang on 5/14/24.
//

import UIKit
import SnapKit

class SignInVC: UIViewController {
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        return button
    }()
    
    private let autoLoginToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = UserDefaults.standard.isAutoLoginEnabled
        return toggle
    }()
    
    private let autoLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "자동 로그인"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(autoLoginLabel)
        view.addSubview(autoLoginToggle)
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.width.equalTo(view).multipliedBy(0.8)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
        }
        
        signInButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
        
        autoLoginLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.right.equalTo(autoLoginToggle.snp.left).offset(-10)
        }
        
        autoLoginToggle.snp.makeConstraints { make in
            make.centerY.equalTo(autoLoginLabel)
            make.left.equalTo(autoLoginLabel.snp.right).offset(10)
        }
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        autoLoginToggle.addTarget(self, action: #selector(autoLoginToggled(_:)), for: .valueChanged)
    }

    
    @objc private func signInTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Invalid input")
            return
        }
        
        Task {
            do {
                let user = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                print("Signed in user: \(user.uid)")
                if autoLoginToggle.isOn {
                    UserDefaults.standard.isLoggedIn = true
                }
                UserDefaults.standard.isAutoLoginEnabled = autoLoginToggle.isOn
                navigateToMainViewController()
            } catch {
                print("Error signing in: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func autoLoginToggled(_ sender: UISwitch) {
        UserDefaults.standard.isAutoLoginEnabled = sender.isOn
    }
    
    private func navigateToMainViewController() {
        let mainVC = ViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
}

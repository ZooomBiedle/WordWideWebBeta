//
//  SignUpVC.swift
//  WordWideWeb
//
//  Created by David Jang on 5/14/24.
//

import UIKit
import SnapKit
import FirebaseAuth

class SignUpVC: UIViewController {
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let emailCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check Email", for: .normal)
        button.isEnabled = false // 초기에는 비활성화
        button.backgroundColor = .gray // 비활성화 색상
        return button
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private var emailChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetEmailCheckState()
    }
    
    private func setupViews() {
        view.addSubview(emailTextField)
        view.addSubview(emailCheckButton)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
        }
        
        emailCheckButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(emailCheckButton.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
        }
        
        registerButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
        }
        
        emailCheckButton.addTarget(self, action: #selector(checkEmailTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    private func setupObservers() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        let isFormValid = isFormValid()
        registerButton.isEnabled = isFormValid && emailChecked // 이메일 확인 후에만 활성화
        
        // 이메일 형식이 올바른지 확인하고, 확인되지 않은 상태에서만 이메일 체크 버튼을 활성화
        if let email = emailTextField.text, isValidEmail(email) {
            if !emailChecked {
                emailCheckButton.isEnabled = true
                emailCheckButton.backgroundColor = .systemBlue // 활성화 색상
            }
        } else {
            emailCheckButton.isEnabled = false
            emailCheckButton.backgroundColor = .gray // 비활성화 색상
        }
    }
    
    private func isFormValid() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            return false
        }
        
        return password == confirmPassword
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc private func checkEmailTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            print("Invalid email")
            return
        }

        Task {
            let emailExists = await AuthenticationManager.shared.checkEmailExists(email: email)
            if emailExists {
                showAlert(title: "Error", message: "이미 가입된 이메일 입니다.")
                clearOtherFields() // 중복된 이메일일 경우 다른 필드의 입력값을 모두 지움
                emailChecked = false // 이메일 검증 상태를 초기화
                emailTextField.isEnabled = true // 이메일 필드를 다시 활성화
            } else {
                showAlert(title: "Success", message: "입력한 이메일 주소로 가입이 가능합니다.")
                emailCheckButton.isEnabled = false // 이메일 확인 후 비활성화
                emailTextField.isEnabled = false // 이메일 필드를 비활성화
                emailCheckButton.backgroundColor = .gray // 비활성화 색상
                emailChecked = true // 이메일이 확인되었음을 표시
            }
        }
    }

    private func clearOtherFields() {
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    private func resetEmailCheckState() {
        emailChecked = false
        textFieldDidChange()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func registerTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Invalid input")
            return
        }

        Task {
            do {
                // 이메일이 이미 검증된 경우에만 등록을 진행합니다.
                if emailChecked {
                    let user = try await AuthenticationManager.shared.createUser(email: email, password: password)
                    print("Registered user: \(user.uid)")
                    
                    // 성공적으로 등록 후 ViewController로 이동
                    navigateToMainViewController()
                } else {
                    // 이메일 검증이 되지 않은 경우 사용자에게 알림
                    showAlert(title: "Check Required", message: "Please check the email for validation first.")
                }
            } catch {
                print("Error registering: \(error.localizedDescription)")
                if let authError = error as NSError?, AuthErrorCode.Code(rawValue: authError.code) == .emailAlreadyInUse {
                    // 이미 사용 중인 이메일일 때 오류 처리
                    showAlert(title: "Registration Failed", message: "This email address is already in use.")
                } else {
                    // 다른 종류의 오류 처리
                    showAlert(title: "Registration Failed", message: "An unexpected error occurred. Please try again.")
                }
            }
        }
    }


    private func navigateToMainViewController() {
        let mainVC = ViewController() // 실제 ViewController 클래스명으로 교체 필요
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }

}

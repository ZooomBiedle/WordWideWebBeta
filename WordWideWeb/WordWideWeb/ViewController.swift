//
//  ViewController.swift
//  WorldWordWeb
//
//  Created by 신지연 on 2024/05/14.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
    }
    
    private func setupViews() {
        titleLabel.text = "WWW"
        
        view.addSubview(titleLabel)
        view.addSubview(logoutButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    @objc private func logoutTapped() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.isLoggedIn = false
            UserDefaults.standard.isAutoLoginEnabled = false
            NotificationCenter.default.post(name: .userDidLogout, object: nil)
            guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
            sceneDelegate.setRootViewController()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

//
//  MyPageWordViewController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/21/24.
//

import UIKit
import SnapKit

// 단어카드 다음페이지 : 단어 리스트 페이지
class MyPageWordViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("back", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.yellow, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(returnMain), for: .touchUpInside)
        return button
    }()
    @objc func returnMain() {
        self.dismiss(animated: true)
    }
    
    lazy var wordButton: UIButton = {
        let button = UIButton()
        button.setTitle("word", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(returnMain), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor")
        layout()
        // Do any additional setup after loading the view.
    }
 
    private func layout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-270)
            make.bottom.equalToSuperview().offset(-730)
        }
        
        view.addSubview(wordButton)
        wordButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-270)
            make.bottom.equalToSuperview().offset(-500)
        }
    }
}


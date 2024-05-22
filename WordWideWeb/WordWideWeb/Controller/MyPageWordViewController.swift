//
//  MyPageWordViewController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/21/24.
//

import UIKit
import SnapKit

// 단어카드 다음페이지 : 단어 리스트 페이지
class MyPageWordViewController: UIViewController {
    
    lazy var wordButton: UIButton = {
        let button = UIButton()
        button.setTitle("world", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.yellow, for: .normal)
        button.addTarget(self, action: #selector(returnMain), for: .touchUpInside)
        return button
    }()
    @objc func returnMain() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor")
        layout()
        // Do any additional setup after loading the view.
    }
 
    private func layout() {
        view.addSubview(wordButton)
        wordButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(20)
        }
    }
}


//
//  MyPageModelViewController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/21/24.
//

import UIKit
import SnapKit

class MyPageModalViewController: UIViewController {
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.text = "World"
        label.textAlignment = .center
        return label
    }()
    
    lazy var pronunciationLabel: UILabel = {
        let label = UILabel()
        label.text = "미국식 [ wɜːrld ] 영국식 [ wɜːld ]"
        label.textAlignment = .center
        return label
    }()
    
    lazy var meaningLabel: UILabel = {
        let label = UILabel()
        label.text = "1. 명사 세계"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(wordLabel)
        
        wordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(20)
        }
      
        pronunciationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(80)
        }
        
        meaningLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(20)
        }
    }
}


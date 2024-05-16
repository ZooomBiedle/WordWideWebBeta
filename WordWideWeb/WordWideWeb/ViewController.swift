//
//  ViewController.swift
//  WorldWordWeb
//
//  Created by 신지연 on 2024/05/14.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var button0 = ButtonFactory().makeButton(title: "sample", corner: 5)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        button0.addAction(UIAction(handler: { _ in
            print("tapped")
        }), for: .touchUpInside)
    }
    
    private func setupViews() {
        titleLabel.text = "WWW"
        
        
        view.addSubview(titleLabel)
        view.addSubview(button0)
        
        titleLabel.snp.makeConstraints { make in
            
            
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        button0.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-200)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
    }
    
    
}


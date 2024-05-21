//
//  PlayingListView.swift
//  WordWideWeb
//
//  Created by 신지연 on 2024/05/21.
//

import Foundation
import UIKit
import SnapKit

class PlayingListView: UIView{
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let topImageLabel: UIImageView = {
        let label = UIImageView()
        label.image = UIImage.smileFace
        return label
    }()
    
    private let searchBar = SearchBarWhite(frame: CGRect(x: 0, y: 0, width: 290, height: 50), placeholder: "Search", cornerRadius: 10)
    
    let filterBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.filter, for: .normal)
        btn.clipsToBounds = true
        return btn
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(size: 20, weight: .semibold)
        label.text = "Task List"
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var resultView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customComponent(){
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.layer.backgroundColor = UIColor.white.cgColor
    }
    
    
    private func setUI(){
        customComponent()
        self.backgroundColor = .bg
        self.addSubview(topImageLabel)
        topImageLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.height.width.equalTo(28)
        }
        
        self.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(topImageLabel.snp.trailing).offset(3)
            make.height.equalTo(28)
            make.width.equalTo(100)
        }
        
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(50)
            make.width.equalTo(290)
        }
        
        self.addSubview(filterBtn)
        filterBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        self.addSubview(resultView)
        resultView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
}

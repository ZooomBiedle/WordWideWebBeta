//
//  InvitingTableViewCell.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/20/24.
//

import UIKit

class InvitingTableViewCell: UITableViewCell {

    static let idenifier = "InvitingTableViewCell"
    
    var section = ListViewCell(frame: .zero)
    
    var wordLabel1 = UILabel()
    var wordLabel2 = UILabel()
    var wordLabel3 = UILabel()
    var wordLabel4 = UILabel()
    var wordLabel5 = UILabel()
    var stackview = UIStackView()
    
    var rejectButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Reject", for: .normal)
        btn.titleLabel?.font = .pretendard(size: 18, weight: .regular)
        btn.titleLabel?.textColor = .white
        btn.tintColor = UIColor(named: "pointRed")
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    var acceptButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Accept", for: .normal)
        btn.titleLabel?.font = .pretendard(size: 18, weight: .regular)
        btn.titleLabel?.textColor = .white
        btn.tintColor = UIColor(named: "mainBtn")
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        [wordLabel1, wordLabel2, wordLabel3, wordLabel4, wordLabel5].forEach {
            stackview.addArrangedSubview($0)
        }
        
        [section, stackview, rejectButton, acceptButton].forEach {
            contentView.addSubview($0)
        }
        
        section.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        stackview.snp.makeConstraints { make in
            make.top.equalTo(section.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(section.snp.horizontalEdges)
        }
        
        rejectButton.snp.makeConstraints { make in
            make.top.equalTo(stackview.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
    }
}

//
//  DictionaryTableViewCell.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/17/24.
//

import UIKit
import SnapKit

class DictionaryTableViewCell: UITableViewCell {
    
    static let identifier = "DictionaryTableViewCell"
    
    var wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(size: 18, weight: .semibold)
        return label
    }()
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus.circle.fill"), for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setImage(UIImage(named: "minus.circle.fill"), for: .selected)
        btn.setTitleColor(UIColor.gray, for: .selected)
        return btn
    }()
    
    var EngLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(size: 18, weight: .regular)
        return label
    }()
    // "\(senseOrder). \(pos)  \(transWord)"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "bgColor")
        setConstraints()
        setAddButton(addButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        [wordLabel, addButton, EngLabel].forEach {
            contentView.addSubview($0)
        }
        
        wordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(wordLabel)
            make.verticalEdges.equalTo(wordLabel)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(wordLabel.snp.height)
        }
        
        EngLabel.snp.makeConstraints { make in
            make.top.equalTo(wordLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    // MARK: - addButton
    func setAddButton(_ button: UIButton) {
        
        let configuration = UIButton.Configuration.tinted()
        button.configuration = configuration
        button.setImage(UIImage(systemName: "plus.fill"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(systemName: "minus.fill"), for: .normal)
        button.tintColor = UIColor.red
        button.titleLabel?.text = ""
        
        let seletedPriority = {(action: UIAction)  in
            
        }
        
        self.addButton.menu = UIMenu(children: [
            UIAction(title: "호텔 필수 영단어", handler: seletedPriority),
            UIAction(title: "개발자 필수 영단어", handler: seletedPriority),
            UIAction(title: "Cancel", handler: seletedPriority)
        ])
        self.addButton.showsMenuAsPrimaryAction = true
        self.addButton.changesSelectionAsPrimaryAction = true
        
    }
    

}

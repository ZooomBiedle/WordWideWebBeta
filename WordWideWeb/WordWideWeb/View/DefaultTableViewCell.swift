//
//  DefaultTableViewCell.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/21/24.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    
    static let identifier = "DefaultTableViewCell"

    var defaultView = ListViewCell(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(defaultView)
        contentView.backgroundColor = UIColor(named: "bgColor")
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        defaultView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

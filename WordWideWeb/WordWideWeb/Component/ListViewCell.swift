//
//  ListViewCell.swift
//  WordWideWeb
//
//  Created by 신지연 on 2024/05/14.
//

import UIKit
import SnapKit

//높이 80기준

class ListViewCell: UIView {
    
    private let imageLabel: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.pretendard(size: 16, weight: .heavy)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.pretendard(size: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.backgroundColor = .clear
        self.imageLabel.clipsToBounds = true
        self.imageLabel.layer.cornerRadius = 25
        
        self.addSubview(imageLabel)
        imageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageLabel.snp.centerY)
            make.leading.equalTo(imageLabel.snp.trailing).offset(20)
        }
        
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-30)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
    }
    
    func bind(imageData: Data?, title: String, date: String){
        if let imageData = imageData {
            imageLabel.image = UIImage(data: imageData)
            imageLabel.layer.borderWidth = 0
            imageLabel.layer.borderColor = UIColor.clear.cgColor
        }
        self.titleLabel.text = title
        self.dateLabel.text = date
    }
}

//
//  BlockCell.swift
//  WordWideWeb
//
//  Created by 신지연 on 2024/05/16.
//
import UIKit
import SnapKit

class BlockCell: UICollectionViewCell {
    
    let term: UILabel = {
        let term = UILabel()
        term.textColor = .black
        term.font = UIFont.pretendard(size: 16, weight: .semibold)
        return term
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bind(text: "")
    }
    
    func bind(text: String) {
        self.term.text = text
    }
    
    func setUI(){
        self.contentView.addSubview(term)
        term.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

//
//  WordbookCell.swift
//  WordWideWeb
//
//  Created by David Jang on 5/20/24.
//

import UIKit

class WordbookCell: UICollectionViewCell {
    
    // UI elements
    private let titleLabel = UILabel()
    private let wordCountLabel = UILabel()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // Setup views
    private func setupViews() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        titleLabel.font = UIFont.pretendard(size: 16, weight: .medium)
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        wordCountLabel.font = UIFont.pretendard(size: 14, weight: .regular)
        wordCountLabel.textColor = .white
        contentView.addSubview(wordCountLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
        
        wordCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }
    
    // Configure cell
    func configure(with wordbook: Wordbook) {
        titleLabel.text = wordbook.title
        wordCountLabel.text = "Words: \(wordbook.wordCount)"
        contentView.backgroundColor = UIColor(hex: wordbook.colorCover)
    }
}


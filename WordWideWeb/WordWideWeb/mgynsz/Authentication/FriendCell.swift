//
//  FriendCell.swift
//  WordWideWeb
//
//  Created by David Jang on 5/17/24.
//

import UIKit
import SDWebImage
import SnapKit

class FriendCell: UITableViewCell {
    
    static let identifier = "FriendCell"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with user: User) {
        nameLabel.text = user.displayName
        if let photoURL = URL(string: user.photoURL ?? ""), !user.photoURL!.isEmpty {
            profileImageView.sd_setImage(with: photoURL, completed: nil)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }
    }
}

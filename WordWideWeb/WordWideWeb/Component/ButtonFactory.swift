//
//  ButtonFactory.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/21/24.
//

import UIKit

class ButtonFactory {
    func makeButton(title: String = "",
                    titleColor: UIColor = .white,
                    backgroundColor: UIColor = .mainBtn,
                    corner: CGFloat = 5.0,
                    width: CGFloat = 140.0,
                    size: CGFloat = 50.0,
                    shadow: CGFloat = 10 ) -> UIButton {
        
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = corner
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.titleLabel?.font = UIFont.pretendard(size: 50, weight: .regular)
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 10
        return button
    }
}

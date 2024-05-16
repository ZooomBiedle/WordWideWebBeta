//
//  ButtonFactory.swift
//  WordWideWeb
//
//  Created by 채나연 on 5/14/24.
//

import UIKit

class ButtonFactory {
    func makeButton(title: String, titleColor: UIColor = .white, backgroundColor: UIColor = .black, corner: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = corner
        return button
    }
}

//
//  LabelFactory.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/21/24.
//

import UIKit

class LabelFactory {
    func makeLabel(text: String,
                   textAlignment: NSTextAlignment = NSTextAlignment.left,
                   textColor: UIColor = .black,
                   font: UIFont = UIFont.pretendard(size: 18, weight: .regular)) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.font = UIFont.pretendard(size: 20, weight: .semibold)
        return label
    }
}

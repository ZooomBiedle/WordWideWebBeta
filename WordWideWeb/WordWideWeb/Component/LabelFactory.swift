//
//  LabelFactory.swift
//  WordWideWeb
//
//  Created by 채나연 on 5/14/24.
//

import UIKit

class LabelFactory {
    func makeLabel(text: String, textAlignment: NSTextAlignment, backgroundColor: UIColor, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.backgroundColor = .black
        label.textColor = .tintColor
        return label
    }
}

//
//  SearchBarWhite.swift
//  WordWideWeb
//
//  Created by 신지연 on 2024/05/15.
//

import SnapKit
import UIKit

class SearchBarWhite: UISearchBar {
    
    private var placeholderTerm: String = "입력해주세요"
    private let barColor: UIColor = .white
    private var cornerRad: Int = 10
    
    init(frame: CGRect, placeholder: String, cornerRadius: Int) {
        super.init(frame: frame)
        self.placeholderTerm = placeholder
        self.cornerRad = cornerRadius
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        self.searchBarStyle = .minimal
        self.searchTextField.borderStyle = .none
        self.searchTextField.backgroundColor = barColor
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = CGFloat(cornerRad)
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
        }
        self.placeholder = placeholderTerm
        
    }
}

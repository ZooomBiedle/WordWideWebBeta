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
    private var barColor: UIColor = .white
    
    init(frame: CGRect, placeholder: String, barColor: UIColor) {
        super.init(frame: frame)
        self.placeholderTerm = placeholder
        self.barColor = barColor
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
        
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
        }
        self.placeholder = placeholderTerm
        
    }
}

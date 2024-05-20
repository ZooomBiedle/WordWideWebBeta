//
//  UIFont+Ext.swift
//  WorldWordWeb
//
//  Created by 신지연 on 2024/05/14.
//

import Foundation
import UIKit

extension UIFont {
    static func pretendard(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "Pretendard"

        var weightString: String
        switch weight {
        case .heavy:
            weightString = "ExtraBold"
        case .ultraLight:
            weightString = "ExtraLight"
        case .semibold:
            weightString = "SemiBold"
        default:
            weightString = "Regular"
        }

        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
}


extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
    func addleftimage(image:UIImage) {
            let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            leftimage.image = image
            self.leftView = leftimage
            self.leftViewMode = .always
        }
}

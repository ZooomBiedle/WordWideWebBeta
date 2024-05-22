//
//  ImageFactory.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/21/24.
//

import UIKit

class ImageFactory {
    func makeImage() -> UIImageView {
        let logo = UIImageView()
        logo.image = UIImage(named: "fakeLogo")
        return logo
    }
}

//
//  UIImage+SetColor.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// Colorize ImageView
    func setColor(to color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

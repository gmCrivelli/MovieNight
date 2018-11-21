//
//  UIImage+Resized.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 17/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(maxSide: CGFloat) -> UIImage? {
        var newSize: CGSize
        let width = self.size.width
        let height = self.size.height
        if width > height {
            newSize = CGSize(width: maxSide, height: maxSide * (height / width))
        } else {
            newSize = CGSize(width: maxSide * (width / height), height: maxSide)
        }

        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return smallImage
    }
}

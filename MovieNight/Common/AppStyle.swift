//
//  Margin.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 25/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

//swiftlint:disable identifier_name

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}

extension UIFont {
    static let title = UIFont.boldSystemFont(ofSize: 26)
    static let body = UIFont.systemFont(ofSize: 17)
    static let summary = UIFont.systemFont(ofSize: 14)
}

enum Margin {
    static let horizontalSmall: CGFloat = 8
    static let horizontalNormal: CGFloat = 16
    static let horizontalLarge: CGFloat = 24
    static let verticalSmall: CGFloat = 8
    static let verticalNormal: CGFloat = 16
    static let verticalLarge: CGFloat = 24
    static let verticalVeryLarge: CGFloat = 72
}

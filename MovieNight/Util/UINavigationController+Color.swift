//
//  UINavigationController+Color.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 13/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

extension UINavigationController {

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorSchemeManager.shared.currentColorScheme.statusBarStyle
    }
}

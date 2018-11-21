//
//  ColorScheme.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 12/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import UIKit

protocol ColorScheme {
    var bgColor: UIColor { get }
    var textColor: UIColor { get }
    var iconColor: UIColor { get }
    var ratingColor: UIColor { get }
    var barColor: UIColor { get }
    var unselectedColor: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
}

fileprivate class LightColorScheme: ColorScheme {
    var bgColor: UIColor { return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
    var textColor: UIColor { return #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1) }
    var iconColor: UIColor { return #colorLiteral(red: 0, green: 0.4199020742, blue: 0.7315359748, alpha: 1) }
    var ratingColor: UIColor { return #colorLiteral(red: 0.2534380326, green: 0, blue: 0.3146137268, alpha: 1) }
    var barColor: UIColor { return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
    var unselectedColor: UIColor { return #colorLiteral(red: 0.4517158488, green: 0.4517158488, blue: 0.4517158488, alpha: 1) }
    var statusBarStyle: UIStatusBarStyle { return .default }
}

fileprivate class DarkColorScheme: ColorScheme {
    var bgColor: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    var textColor: UIColor { return #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1) }
    var iconColor: UIColor { return #colorLiteral(red: 1, green: 0.6039383411, blue: 0, alpha: 1) }
    var ratingColor: UIColor { return #colorLiteral(red: 0.8539663462, green: 0.786841281, blue: 0.1217163528, alpha: 1) }
    var barColor: UIColor { return #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1) }
    var unselectedColor: UIColor { return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) }
    var statusBarStyle: UIStatusBarStyle { return .lightContent }
}

fileprivate class NapolitanColorScheme: ColorScheme {
    var bgColor: UIColor { return #colorLiteral(red: 1, green: 0.9275574144, blue: 0.8304729913, alpha: 1) }
    var textColor: UIColor { return #colorLiteral(red: 0.415823939, green: 0.2310154543, blue: 0, alpha: 1) }
    var iconColor: UIColor { return #colorLiteral(red: 0.9219475298, green: 0.4832788596, blue: 0.6509387597, alpha: 1) }
    var ratingColor: UIColor { return #colorLiteral(red: 0, green: 0.4046647049, blue: 0.2303291392, alpha: 1) }
    var barColor: UIColor { return #colorLiteral(red: 0.9334279675, green: 0.8652980342, blue: 0.7748897742, alpha: 1) }
    var unselectedColor: UIColor { return #colorLiteral(red: 0.5662301061, green: 0.5249015615, blue: 0.4700586808, alpha: 1) }
    var statusBarStyle: UIStatusBarStyle { return .default }
}

enum ColorSchemeType: Int {
    case light = 0
    case dark = 1
    case napolitan = 2
    
    func instance() -> ColorScheme {
        switch self {
        case .light:
            return LightColorScheme()
        case .dark:
            return DarkColorScheme()
        default:
            return NapolitanColorScheme()
        }
    }
}

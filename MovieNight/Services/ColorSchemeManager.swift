//
//  ColorSchemeManager.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 12/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import UIKit

class ColorSchemeManager {

    // Singleton Instance
    static let shared = ColorSchemeManager()

    // Properties
    private let userDefaults = UserDefaults.standard
    var currentColorScheme: ColorScheme = ColorSchemeType(rawValue: 0)!.instance()

    // Private initializer
    private init() {
        reloadColorScheme()
    }

    // MARK: - Methods
    func reloadColorScheme() {
        if let schemeType = ColorSchemeType(rawValue: userDefaults.integer(forKey: UserDefaults.Keys.color)) {
            self.currentColorScheme = schemeType.instance()
        }
    }

    func saveColorScheme(to schemeType: ColorSchemeType) {
        userDefaults.set(schemeType.rawValue, forKey: UserDefaults.Keys.color)
        reloadColorScheme()
    }
}

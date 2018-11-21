//
//  Date+Formatted.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 17/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

extension Date {
    var formatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy, HH:mm"
        return dateFormatter.string(from: self)
    }
}

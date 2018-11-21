//
//  CustomError.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

enum CustomErrors: Error {
    case fileNotFound
}

extension CustomErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return NSLocalizedString("Missing file in assets.", comment: "")
        }
    }
}

//
//  CodeView.swift
//  ViewCode
//
//  Created by Eric Brito
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation

protocol CodeView {
    func setupComponents()
    func setupConstraints()
    func setupExtraConfiguration()
    func reloadColor()
    func reloadI18N()
    func setup()
}

extension CodeView {
    func setup() {
        setupComponents()
        setupConstraints()
        setupExtraConfiguration()
        reloadColor()
    }
}

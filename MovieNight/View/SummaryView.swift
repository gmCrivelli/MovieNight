//
//  SummaryView.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 07/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

@IBDesignable
class SummaryView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            setupView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}

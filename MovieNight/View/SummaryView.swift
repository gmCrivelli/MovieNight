//
//  SummaryView.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 07/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import Cartography

final class SummaryView: UIView {

    let csManager = ColorSchemeManager.shared

    let summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sinopse:"
        label.font = .body
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Mussum ipsum, cacilds vidis litro abertis."
        label.font = .summary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    init(summary: String) {
        self.summaryLabel.text = summary
        super.init(frame: .zero)
        setup()
    }

    //Sempre necessário pois é usado por exemplo quando a View vem a partir do XIB ou Storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SummaryView: CodeView {
    
    func reloadColor() {
        summaryLabel.textColor = .white
                summaryTitleLabel.textColor = .white
    }

    func setupComponents() {
        addSubview(summaryTitleLabel)
        addSubview(summaryLabel)
    }

    func setupConstraints() {

        //Título

         constrain(summaryTitleLabel, self) { view, superview in
         view.top == superview.top + Margin.verticalSmall
         view.left == superview.left + Margin.horizontalSmall
         view.right == superview.right - Margin.horizontalSmall
         }

        //Corpo

        constrain(summaryLabel, summaryTitleLabel) {
            $0.top == $1.bottom + Margin.verticalSmall
            $0.left == $1.left
            $0.right == $1.right
        }
        summaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        constrain(summaryLabel, self) { view, superview in
            view.bottom == superview.bottom - Margin.verticalSmall
        }
    }

    func setupExtraConfiguration() {
        self.backgroundColor = #colorLiteral(red: 0.1607621908, green: 0.1607970595, blue: 0.1607599854, alpha: 1)
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }

    func reloadI18N() {
        print("Summary view i18n")
    }
}

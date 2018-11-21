//
//  MovieListTableViewCell.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var posterImg: UIImageView!

    // MARK: - Super Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Methods
    func prepare(with movie: CDMovie, colorScheme: ColorScheme) {

        self.titleLbl.text = movie.title
        let summary = movie.summary ?? ""
        if summary != "" {
            self.summaryLbl.text = summary
        } else {
            self.summaryLbl.text = "Sem sinopse!"
        }

        if movie.rating >= 0.0 {
            self.ratingLbl.text = "⭐️ \(movie.rating)/10.0"
        } else {
            self.ratingLbl.text = "⭐️ Sem nota!"
        }

        if let imageData = movie.image {
            self.posterImg.image = UIImage(data: imageData)
        } else {
            self.posterImg.image = UIImage(named: "cinema")
        }

        self.setupColorScheme(with: colorScheme)
    }

    private func setupColorScheme(with colorScheme: ColorScheme) {
        titleLbl.textColor = colorScheme.textColor
        summaryLbl.textColor = colorScheme.textColor
        ratingLbl.textColor = colorScheme.ratingColor
        backgroundColor = colorScheme.bgColor
    }
}

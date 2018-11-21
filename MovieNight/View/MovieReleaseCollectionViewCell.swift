//
//  MovieReleaseCollectionViewCell.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MovieReleaseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImg: UIImageView!

    func prepare(with movie: JMovie) {
        if let imageName = movie.image {
            self.posterImg.image = UIImage(named: imageName)
        } else {
            self.posterImg.image = nil
        }
    }
}

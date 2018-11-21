//
//  NewMoviesTableViewCell.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class MovieReleasesTableViewCell: UITableViewCell {

    var movies: [JMovie] = []

    @IBOutlet weak var lblReleases: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Super Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout
        }
    }

    // MARK: Methods
    func prepare(with movie: JMovie, colorScheme: ColorScheme) {
        guard let items = movie.items else { return }
        self.movies = items
        self.collectionView.reloadData()
        self.setupColorScheme(with: colorScheme)
    }

    private func setupColorScheme(with colorScheme: ColorScheme) {
        lblReleases.textColor = colorScheme.textColor
        backgroundColor = colorScheme.bgColor
    }
}

extension MovieReleasesTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "releasesCvCell",
                                                         for: indexPath) as? MovieReleaseCollectionViewCell {

            cell.prepareForReuse()
            cell.prepare(with: movies[indexPath.item])
            return cell
        }

        return UICollectionViewCell()
    }
}

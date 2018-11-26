//
//  MovieView.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 25/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import Cartography
import AVFoundation

protocol MovieViewDelegate: class {
    func reminderButtonPressed()
    func playButtonPressed()
}

final class MovieView: UIView {

    weak var delegate: MovieViewDelegate?
    var playerLayer: AVPlayerLayer?

    let csManager = ColorSchemeManager.shared

    let posterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cinema"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let gradientImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gradientWhite"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let buttonPlay: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Título do Filme"
        label.font = .title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Categorias do Filme"
        label.font = .body
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "153 min"
        label.font = .body
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Nota do filme"
        label.font = .body
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let summaryView: SummaryView = {
       return SummaryView(summary: Localization.noSummary)
    }()

    let buttonReminder: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.reminderButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(delegate: MovieViewDelegate, movie: CDMovie?) {
        self.delegate = delegate
        super.init(frame: .zero)
        setup()
        setupContent(with: movie)
    }

    //Sempre necessário pois é usado por exemplo quando a View vem a partir do XIB ou Storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func reminderButtonPressed() {
        delegate?.reminderButtonPressed()
    }

    @objc private func playButtonPressed() {
        delegate?.playButtonPressed()
    }

    func setupContent(with movie: CDMovie?) {
        if let movie = movie {
            movieTitleLabel.text = movie.title
            durationLabel.text = movie.duration ?? "??? min"
            if let summary = movie.summary, summary != "" {
                summaryView.summaryLabel.text = movie.summary
            } else {
                summaryView.summaryLabel.text = Localization.noSummary
            }
            categoryLabel.text = movie.categories?
                .split(separator: ",")
                .joined(separator: " | ") ?? Localization.noCategories

            if movie.rating >= 0.0 {
                ratingLabel.text = "⭐️ \(movie.rating) / 10.0"
            } else {
                ratingLabel.text = "⭐️ ??? / 10.0"
            }

            if let imageData = movie.image {
                posterImageView.image = UIImage(data: imageData)
            } else {
                posterImageView.image = UIImage(named: "cinema")
            }

            buttonPlay.isHidden = false
            gradientImageView.isHidden = false
        }
    }

    func playTrailer(player: AVPlayer) {
        playerLayer = AVPlayerLayer(player: player)
        if let playerLayer = playerLayer {
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.frame = posterImageView.bounds
            posterImageView.layer.addSublayer(playerLayer)
            playerLayer.player?.play()
        }

        self.gradientImageView.isHidden = true
        self.buttonPlay.isHidden = true
    }

    func stopTrailer() {
        if let playerLayer = playerLayer {
            playerLayer.removeFromSuperlayer()
            self.playerLayer = nil
        }
    }
}

extension MovieView: CodeView {

    func setupComponents() {
        addSubview(posterImageView)
        addSubview(gradientImageView)
        addSubview(buttonPlay)
        addSubview(movieTitleLabel)
        addSubview(categoryLabel)
        addSubview(durationLabel)
        addSubview(ratingLabel)
        addSubview(summaryView)
        addSubview(buttonReminder)
    }

    func setupConstraints() {
        // Poster Image
        constrain(posterImageView, self) { (view, superview) in
            view.top == superview.safeAreaLayoutGuide.top
            view.left == superview.safeAreaLayoutGuide.left
            view.right == superview.safeAreaLayoutGuide.right
            view.height == 200.0
        }

        // Play Button
        constrain(buttonPlay, posterImageView) { (button, poster) in
            button.centerX == poster.centerX
            button.centerY == poster.centerY
        }

        // Gradient
        constrain(gradientImageView, posterImageView) { (gradient, poster) in
            gradient.leading == poster.leading
            gradient.bottom == poster.bottom
            gradient.width == poster.width
        }

        // Movie Title
        constrain(movieTitleLabel, posterImageView) { (title, poster) in
            title.top == poster.bottom + Margin.verticalNormal
            title.leading == poster.leading + Margin.horizontalNormal
            title.trailing == poster.trailing - Margin.horizontalNormal
        }

        // Categories + Duration
        constrain(categoryLabel, durationLabel, movieTitleLabel) { (category, duration, title) in
            category.top == title.bottom + Margin.verticalSmall
            category.leading == title.leading
            category.trailing >= duration.leading - Margin.horizontalSmall
            duration.trailing == title.trailing
            duration.top == category.top
        }
        categoryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // Rating
        constrain(ratingLabel, categoryLabel, movieTitleLabel) { (rating, category, title) in
            rating.top == category.bottom + Margin.verticalSmall
            rating.leading == category.leading
            rating.trailing == title.trailing
        }

        // Summary
        constrain(summaryView, ratingLabel, movieTitleLabel) { (summary, rating, title) in
            summary.top == rating.bottom + Margin.verticalNormal
            summary.leading == rating.leading
            summary.trailing == title.trailing
            summary.height >= 80
        }

        // Reminder Button
        constrain(buttonReminder, summaryView, self) { (reminder, summary, superview) in
            reminder.centerX == superview.centerX
            reminder.bottom == superview.safeAreaLayoutGuide.bottom - Margin.verticalNormal
            reminder.top >= summary.bottom + Margin.verticalNormal
        }
    }

    func setupExtraConfiguration() {
        buttonPlay.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        buttonReminder.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
    }

    func reloadColor() {
        csManager.reloadColorScheme()

        self.backgroundColor = csManager.currentColorScheme.bgColor

        gradientImageView.setColor(to: csManager.currentColorScheme.bgColor)
        movieTitleLabel.textColor = csManager.currentColorScheme.textColor
        categoryLabel.textColor = csManager.currentColorScheme.textColor
        durationLabel.textColor = csManager.currentColorScheme.textColor
        ratingLabel.textColor = csManager.currentColorScheme.ratingColor
        buttonReminder.setTitleColor(csManager.currentColorScheme.iconColor, for: .normal)
        summaryView.reloadColor()
    }

    func reloadI18N() {
        summaryView.reloadI18N()
    }
}

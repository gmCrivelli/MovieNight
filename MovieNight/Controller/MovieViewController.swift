//
//  MovieViewController.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 07/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

@IBDesignable
class MovieViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var categoriesLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var gradientImg: UIImageView!
    @IBOutlet weak var btnReminder: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var summaryTitleLabel: UILabel!

    // MARK: - Properties
    var movie: CDMovie?
    var alert: UIAlertController?
    var playerLayer: AVPlayerLayer?

    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(didChangeDatePickerValue(_:)), for: .valueChanged)
        return datePicker
    }()

    // MARK: - Super Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForNotifications()
        self.setupView()
        self.reloadColor()
        self.reloadAutoplay()
        self.reloadI18N()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    /// Register the VC for notifications, where the UI will have to be updated
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadColor),
                                               name: NSNotification.Name(UNKeys.colorUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadAutoplay),
                                               name: NSNotification.Name(UNKeys.autoplayUpdate), object: nil)
    }

    func setupView() {
        if let movie = movie {
            movieTitleLbl.text = movie.title
            durationLbl.text = movie.duration ?? "??? min"
            if let summary = movie.summary, summary != "" {
                summaryLbl.text = movie.summary
            } else {
                summaryLbl.text = Localization.noSummary
            }
            categoriesLbl.text = movie.categories?
                .split(separator: ",")
                .joined(separator: " | ") ?? Localization.noCategories

            if movie.rating >= 0.0 {
               ratingLbl.text = "⭐️ \(movie.rating) / 10.0"
            } else {
               ratingLbl.text = "⭐️ ??? / 10.0"
            }

            if let imageData = movie.image {
                self.posterImg.image = UIImage(data: imageData)
            } else {
                self.posterImg.image = UIImage(named: "cinema")
            }

            btnPlay.isHidden = false
            gradientImg.isHidden = false
        }
    }

    @objc func reloadColor() {
        csManager.reloadColorScheme()

        self.view.backgroundColor = csManager.currentColorScheme.bgColor

        for subview in self.view.subviews {
            if let label = subview as? UILabel {
                label.textColor = csManager.currentColorScheme.textColor
            }
        }

        self.gradientImg.setColor(to: csManager.currentColorScheme.bgColor)
        self.ratingLbl.textColor = csManager.currentColorScheme.ratingColor

        self.navigationController?.navigationBar.barTintColor = csManager.currentColorScheme.barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
            csManager.currentColorScheme.textColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
            csManager.currentColorScheme.textColor]

        self.tabBarController?.tabBar.barTintColor = csManager.currentColorScheme.barColor
        self.tabBarController?.tabBar.unselectedItemTintColor = csManager.currentColorScheme.unselectedColor

        self.view.window?.tintColor = csManager.currentColorScheme.iconColor

        setNeedsStatusBarAppearanceUpdate()
    }

    @objc func reloadAutoplay() {
        let autoplayIsOn = UserDefaults.standard.bool(forKey: UserDefaults.Keys.autoplay)
        if autoplayIsOn && self.playerLayer == nil {
            self.playTrailerPressed(self)
        }
    }

    func reloadI18N() {
        self.title = Localization.movie
        self.summaryTitleLabel.text = Localization.summary
        self.btnReminder.setTitle(Localization.reminderButton, for: .normal)
    }

    func loadMovieTrailer(_ url: URL) {

        let player = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: url),
                                                       automaticallyLoadedAssetKeys: ["playable"]))

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.frame = posterImg.bounds
        posterImg.layer.addSublayer(playerLayer)
        playerLayer.player?.play()
        playerLayer.player?.pause()
        self.playerLayer = playerLayer

        self.gradientImg.isHidden = true
        self.btnPlay.isHidden = true
    }

    // Display an alert to notify user that there was an error when showing the trailer
    func displayError(_ error: APIError) {
        var message = ""
        switch error {
        case .internalError:
            message = Localization.internalError
        case .notFound:
            message = Localization.notFoundError
        default:
            message = Localization.defaultError
        }

        // Create the alert controller.
        let alert = UIAlertController(title: Localization.error,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localization.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions
    @IBAction func playTrailerPressed(_ sender: Any) {
        REST.trailerUrl(from: movie?.title ?? "",
                  onComplete: { [weak self] (videoUrl) in
                    DispatchQueue.main.async {
                        self?.loadMovieTrailer(videoUrl)
                    }
            }, onError: { [weak self] (error: APIError) in
                self?.displayError(error)
        })
    }

    @IBAction func reminderBtnPressed(_ sender: Any) {
        // Create the alert controller.
        let alert = UIAlertController(title: Localization.reminder,
                                      message: Localization.reminderMessage,
                                      preferredStyle: .alert)

        // Add the text field
        alert.addTextField { (textField) in
            textField.inputView = self.datePicker
            textField.text = self.datePicker.date.formatted
        }

        alert.addAction(UIAlertAction(title: Localization.createReminder, style: .default) { [weak self] (_) in
            if let movie = self?.movie, let date = self?.datePicker.date {
                self?.scheduleNotification(for: movie, on: date)
            }
        })
        alert.addAction(UIAlertAction(title: Localization.cancel, style: .cancel, handler: nil))

        // Present the alert.
        self.alert = alert
        self.datePicker.date = Date()
        self.present(alert, animated: true, completion: nil)
    }

    @objc func didChangeDatePickerValue(_ sender: Any) {
        self.alert?.textFields?.first?.text = datePicker.date.formatted
    }

    func displayNotificationDeniedMessage() {
        let alertMessage = UIAlertController(title: Localization.permissionNeeded,
                                             message: Localization.permissionNeededMessage,
                                             preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: Localization.understood, style: .default, handler: nil))
        self.present(alertMessage, animated: true, completion: nil)
    }

    func scheduleNotification(for movie: CDMovie, on date: Date) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (success, error) in
            print(success)
        }

        center.getNotificationSettings { [weak self] (settings) in
            if settings.authorizationStatus == .denied {
                self?.displayNotificationDeniedMessage()
            }
        }

        let notificationID = String(Date().timeIntervalSince1970)
        let content = UNMutableNotificationContent()
        content.title = Localization.notificationTitle
        content.body = Localization.notificationBodyFirst + (movie.title ?? "") + Localization.notificationBodySecond
        content.categoryIdentifier = "Lembrete"

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                             from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditor", let destination = segue.destination as? EditAddMovieViewController {
            destination.movie = self.movie
        }
    }

    @IBAction func unwindToMovieVC(segue: UIStoryboardSegue) {
    }
}

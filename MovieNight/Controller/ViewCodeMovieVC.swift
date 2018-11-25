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
class ViewCodeMovieVC: UIViewController {

    // MARK: - Properties
    var customView: MovieView {
        guard let customView = view as? MovieView else {
            fatalError("View deveria ser \(MovieView.self) mas foi \(type(of: view))")
        }
        return customView
    }

    var movie: CDMovie?
    var alert: UIAlertController?
    var isPlaying = false

    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(didChangeDatePickerValue(_:)), for: .valueChanged)
        return datePicker
    }()

    // MARK: - Super Methods
    override func loadView() {
        self.view = MovieView(delegate: self, movie: movie)
    }

    @objc func editMovie() {
        self.performSegue(withIdentifier: "showEditorSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let editButton = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(editMovie))
        self.navigationItem.rightBarButtonItem = editButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForNotifications()
        self.reloadColor()
        self.reloadAutoplay()
        self.customView.setupContent(with: movie)
        //reloadI18N()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.customView.stopTrailer()
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

    @objc func reloadColor() {
        csManager.reloadColorScheme()

        self.customView.reloadColor()
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
        if autoplayIsOn && !isPlaying {
            self.playButtonPressed()
        }
    }

    func loadMovieTrailer(_ url: URL) {
        if !isPlaying {
            let player = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: url),
                                                           automaticallyLoadedAssetKeys: ["playable"]))

            self.customView.playTrailer(player: player)
            self.isPlaying = true
        }
    }

    // Display an alert to notify user that there was an error when showing the trailer
    func displayError(_ error: APIError) {
        var message = ""
        switch error {
        case .internalError:
            message = "Erro interno, entre em contato com os administradores."
        case .notFound:
            message = "Trailer não encontrado!"
        default:
            message = "Falha ao buscar dados no servidor."
        }

        // Create the alert controller.
        let alert = UIAlertController(title: "Erro",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func didChangeDatePickerValue(_ sender: Any) {
        self.alert?.textFields?.first?.text = datePicker.date.formatted
    }

    func displayNotificationDeniedMessage() {
        let alertMessage = UIAlertController(title: "Permissão necessária",
                                             message: "Para receber lembretes de filmes, autorize o envio de notificações nas configurações do seu aparelho.",
                                             preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "Entendido!", style: .default, handler: nil))
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
        content.title = "🍿 Pegue sua pipoca, é hora do filme!"
        content.body = "Só passei aqui para te lembrar de ver o filme \"\(movie.title ?? "")\". Boa diversão!"
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
        if segue.identifier == "showEditorSegue", let destination = segue.destination as? EditAddMovieViewController {
            destination.movie = self.movie
        }
    }

    @IBAction func unwindToMovieVC(segue: UIStoryboardSegue) {
    }
}

extension ViewCodeMovieVC: MovieViewDelegate {
    func reminderButtonPressed() {
        // Create the alert controller.
        let alert = UIAlertController(title: "Lembrete",
                                      message: "Selecione uma data e hora para ser lembrado de assistir o filme!",
                                      preferredStyle: .alert)

        // Add the text field
        alert.addTextField { (textField) in
            textField.inputView = self.datePicker
            textField.text = self.datePicker.date.formatted
        }

        alert.addAction(UIAlertAction(title: "Criar lembrete", style: .default) { [weak self] (_) in
            if let movie = self?.movie, let date = self?.datePicker.date {
                self?.scheduleNotification(for: movie, on: date)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        // Present the alert.
        self.alert = alert
        self.datePicker.date = Date()
        self.present(alert, animated: true, completion: nil)
    }

    func playButtonPressed() {
        guard !isPlaying else { return }

        REST.trailerUrl(from: movie?.title ?? "",
                        onComplete: { [weak self] (videoUrl) in
                            DispatchQueue.main.async {
                                self?.loadMovieTrailer(videoUrl)
                            }
            }, onError: { [weak self] (error: APIError) in
                self?.displayError(error)
        })
    }

}

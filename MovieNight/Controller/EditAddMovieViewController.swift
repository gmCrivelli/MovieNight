//
//  EditAddMovieViewController.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 09/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class EditAddMovieViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var movieTitleTf: UITextField!
    @IBOutlet weak var movieSummaryTv: UITextView!
    @IBOutlet weak var ratingSlider: UISlider!

    @IBOutlet weak var categoriesTf: UITextField!
    @IBOutlet weak var durationHoursTf: UITextField!
    @IBOutlet weak var durationMinutesTf: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var secondaryRatingLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var posterImage: UIImageView!

    // MARK: - Properties
    var movie: CDMovie?

    // MARK: - Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
       self.deleteButton.layer.cornerRadius = 10.0
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.scrollView.keyboardDismissMode = .onDrag

        self.setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForNotifications()
        self.reloadColor()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    /// Register the VC for notification events, where the UI will have to be updated
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadColor),
                                               name: NSNotification.Name(UNKeys.colorUpdate), object: nil)
    }

    /// Configure the view using the given movie, if it exists. If there is a movie, display as editing screen.
    /// If there's no movie, display a registering screen to create one.
    ///
    /// - Parameter movie: Model from which to get the data.
    func setupView() {

        // Editing an existing movie
        if let movie = movie {
            movieTitleTf.text = movie.title
            durationMinutesTf.text = movie.duration ?? "???"
            if let summary = movie.summary, summary != "" {
                movieSummaryTv.text = movie.summary
            } else {
                movieSummaryTv.text = "Sem sinopse!"
            }
            categoriesTf.text = movie.categories ?? "Sem categoria"

            if movie.rating >= 0.0 {
                ratingLbl.text = "⭐️ \(movie.rating)"
                ratingSlider.value = Float(movie.rating * 10.0)
            } else {
                ratingLbl.text = "⭐️ ???"
            }

            if let imageData = movie.image {
                posterImage.image = UIImage(data: imageData)
            } else {
                posterImage.image = UIImage(named: "cinema")
            }

            deleteButton.isHidden = false
            self.title = "Editar Filme"
        } else {
            movieTitleTf.text = ""
            durationMinutesTf.text = ""
            durationHoursTf.text = ""
            movieSummaryTv.text = ""
            categoriesTf.text = ""
            ratingLbl.text = "⭐️ 6.0"
            ratingSlider.value = 60.0
            posterImage.image = UIImage(named: "cinema")
            deleteButton.isHidden = true
            self.title = "Cadastrar Filme"
        }

        self.movieSummaryTv.layer.borderWidth = 1.0
    }

    @objc func reloadColor() {
        csManager.reloadColorScheme()

        self.contentView.backgroundColor = csManager.currentColorScheme.bgColor

        self.view.backgroundColor = csManager.currentColorScheme.bgColor

        for subview in self.contentView.subviews {
            if let label = subview as? UILabel {
                label.textColor = csManager.currentColorScheme.textColor
            }
        }

        self.ratingLbl.textColor = csManager.currentColorScheme.ratingColor
        self.secondaryRatingLbl.textColor = csManager.currentColorScheme.ratingColor
        self.movieSummaryTv.layer.borderColor = #colorLiteral(red: 0.8680267739, green: 0.8680267739, blue: 0.8680267739, alpha: 1)

        self.view.window?.tintColor = csManager.currentColorScheme.iconColor

        self.tabBarController?.tabBar.barTintColor = csManager.currentColorScheme.barColor
        self.tabBarController?.tabBar.unselectedItemTintColor = csManager.currentColorScheme.unselectedColor

        self.navigationController?.navigationBar.barTintColor = csManager.currentColorScheme.barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
            csManager.currentColorScheme.textColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
            csManager.currentColorScheme.textColor]

        setNeedsStatusBarAppearanceUpdate()
    }

    /// Update scroll view constraints to fit keyboard when it will show.
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let cgRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let height = cgRect.size.height

            scrollView.contentInset.bottom = height
            scrollView.scrollIndicatorInsets.bottom = height
        }
    }

    /// Update scroll view constraints when keyboard will hide.
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }

    /// Display the source for the poster picture.
    ///
    /// - Parameter sourceType: user-chosen source.
    func selectPicture(from sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Action Outlets

    @IBAction func addPosterImage(_ sender: Any) {
        let alert = UIAlertController(title: "Pôster do Filme",
                                      message: "Escolha de onde recuperar o pôster",
                                      preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
                self?.selectPicture(from: .camera)
            }
            alert.addAction(cameraAction)
        }

        let albumAction = UIAlertAction(title: "Album de Fotos", style: .default) { [weak self] (_) in
            self?.selectPicture(from: .savedPhotosAlbum)
        }
        alert.addAction(albumAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    /// User changed the rating slider. Update labels accordingly.
    @IBAction func ratingChanged(_ sender: UISlider) {
        let rating = Double(round(sender.value)) / 10
        ratingLbl.text = "⭐️ \(rating)"
    }

    /// User pressed the "Delete" button. Confirm destructive action, and delete movie from database if necessary.
    @IBAction func deleteMovie(_ sender: Any) {

        let alert = UIAlertController(title: "Atenção!",
                                      message: "Tem certeza de que deseja deletar este filme? Esta ação não pode ser desfeita.",
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Deletar Filme",
                                      style: .destructive,
                                      handler: { [weak self] action in
                                                    if let movie = self?.movie {
                                                        self?.context?.delete(movie)
                                                    }
                                                    self?.unwindToMovieList()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = #colorLiteral(red: 0.01066807099, green: 0.3691979647, blue: 0.7817171216, alpha: 1)
    }

    /// Save the current movie data in CoreData and unwind VC
    @IBAction func doneBtnPressed(_ sender: Any) {

        // Update existing movie
        if let cdMovie = movie {

            cdMovie.title = movieTitleTf.text
            let hours = durationHoursTf.text ?? "0"
            let minutes = durationMinutesTf.text ?? "0"
            cdMovie.duration = hours + "h " + minutes + "m"
            cdMovie.categories = categoriesTf.text
            cdMovie.rating = Double(round(ratingSlider.value)) / 10

            if let summary = movieSummaryTv.text, summary.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                cdMovie.summary = summary
            } else {
                cdMovie.summary = "Sem sinopse!"
            }

            if let imageData = posterImage.image?.jpegData(compressionQuality: 75) {
                cdMovie.image = imageData
            } else {
                cdMovie.image = UIImage(named: "cinema")?.jpegData(compressionQuality: 75)
            }

            saveContext()
            unwindToMovie()

        } else if let context = context {
            // Create new movie entry
            let movie = CDMovie(context: context)

            movie.title = movieTitleTf.text
            let hours = durationHoursTf.text ?? "0"
            let minutes = durationMinutesTf.text ?? "0"
            movie.duration = hours + "h " + minutes + "m"
            movie.categories = categoriesTf.text
            movie.rating = Double(round(ratingSlider.value)) / 10

            if let summary = movieSummaryTv.text, summary.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                movie.summary = summary
            } else {
                movie.summary = "Sem sinopse!"
            }

            if let imageData = posterImage.image?.jpegData(compressionQuality: 75) {
                movie.image = imageData
            } else {
                movie.image = UIImage(named: "cinema")?.jpegData(compressionQuality: 75)
            }

            self.movie = movie

            saveContext()
            unwindToMovieList()
        }
    }

    // MARK: - Navigation

    func unwindToMovie() {
        performSegue(withIdentifier: "unwindSegueToMovieVC", sender: nil)
    }

    func unwindToMovieList() {
        performSegue(withIdentifier: "unwindSegueToMovieListVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegueToMovieVC", let destination = segue.destination as? MovieViewController {
            destination.movie = movie
        }
    }
}

extension EditAddMovieViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController( _ picker: UIImagePickerController,
                                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        posterImage.image = image.resized(maxSide: 800)
        dismiss(animated: true, completion: nil)
    }
}

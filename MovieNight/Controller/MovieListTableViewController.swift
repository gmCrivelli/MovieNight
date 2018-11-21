//
//  MovieListTableViewController.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData

class MovieListTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bufferView: UIView!
    
    // MARK: - Properties
    var fetchedResultController: NSFetchedResultsController<CDMovie>? = nil
    
    var movies: [CDMovie] {
        return fetchedResultController?.fetchedObjects ?? []
    }
    var selectedMovie: CDMovie?
    
    var noDataLbl: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return csManager.currentColorScheme.statusBarStyle
    }
    
    // MARK: Super Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If it is the first launch, load movies from JSON into CoreData model
        firstLaunchSetup()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.noDataLbl = UILabel(frame: CGRect(x: 0, y: 0,
                                               width: self.tableView.bounds.size.width,
                                               height: self.tableView.bounds.size.height
        ))
        noDataLbl.text = "Nenhum filme cadastrado... Ainda!"
        noDataLbl.textColor = UIColor.white
        noDataLbl.textAlignment = .center
        
        self.loadMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForNotifications()
        self.reloadColor()
        self.updateTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    /// Register the VC to respond to notification events
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadColor), name: NSNotification.Name(UNKeys.colorUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMovies), name: NSNotification.Name(UNKeys.dataUpdate), object: nil)
    }
    
    /// Update the color scheme in the current VC
    @objc func reloadColor() {
        csManager.reloadColorScheme()
        
        self.view.backgroundColor = csManager.currentColorScheme.bgColor
        self.bufferView.backgroundColor = csManager.currentColorScheme.bgColor
        
        self.noDataLbl.textColor = csManager.currentColorScheme.textColor
        
        self.navigationController?.navigationBar.barTintColor = csManager.currentColorScheme.barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: csManager.currentColorScheme.textColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: csManager.currentColorScheme.textColor]
        
        self.tabBarController?.tabBar.barTintColor = csManager.currentColorScheme.barColor
        self.tabBarController?.tabBar.unselectedItemTintColor = csManager.currentColorScheme.unselectedColor
        
        setNeedsStatusBarAppearanceUpdate()
        
        self.tableView.reloadData()
    }
    
    /// Fetch the movie list from the movie service
    @objc func loadMovies() {
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()

        let sortDescriptor = NSSortDescriptor(keyPath: \CDMovie.title, ascending: true)

        // Predicate filters:
        // [c] -> ignore upper/lowercase
        // [d] -> diacritico, ignorar acentos
        // let filter = ""
        // let predicate = NSPredicate(format: "title contains [cd] %@", filter)

        // fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultController = NSFetchedResultsController<CDMovie>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate = self
        do {
            try fetchedResultController?.performFetch()
        }
        catch {
            print(error)
        }
    }
    
    /// Update table view with a given set of movies
    func updateTableView() {
        self.tableView.reloadData()
        if movies.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        else {
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView = noDataLbl
        }
    }
    
    /// Check if it is the first launch. If it is, then load objects from JSON
    /// into the CoreData model.
    private func firstLaunchSetup() {
        let launchedBefore = UserDefaults.standard.bool(forKey: UserDefaults.Keys.launchedBefore)
        guard !launchedBefore else { return }
        
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.launchedBefore)
        
        self.jsonIntoCoreData()
    }
    
    /// Load objects from JSON into CoreData model.
    private func jsonIntoCoreData() {
        let movieService = JMovieService()
        movieService.fetchMovies { [weak self] (movies, error) in
            if let error = error {
                print(error)
                return
            }
            for movie in movies {
                guard let type = movie.itemType, type == .movie else { continue }
                
                let cdMovie = CDMovie(context: context)
                cdMovie.title = movie.title
                cdMovie.duration = movie.duration
                cdMovie.categories = movie.categories?.joined(separator: ", ")
                cdMovie.rating = movie.rating ?? -1.0
                cdMovie.summary = movie.summary
                if let imageName = movie.image {
                    cdMovie.image = UIImage(named: imageName)?.resized(maxSide: 800)?.jpegData(compressionQuality: 75)
                }
                saveContext()
            }
            self?.loadMovies()
        }
    }
    
    /// Deletes all entries in the Movie entity table.
    private func deleteAllMovies() {
        let movieRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDMovie")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: movieRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovie", let destination = segue.destination as? MovieViewController {
            destination.movie = self.selectedMovie
        }
    }
    
    @IBAction func unwindToMovieListVC(segue: UIStoryboardSegue) {
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = movies[indexPath.row]
        
//        if let itemType = movie.itemType {
//            switch itemType {
//            case .list:
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "releasesCell", for: indexPath) as? MovieReleasesTableViewCell {
//                    cell.prepareForReuse()
//                    cell.prepare(with: movie, colorScheme: csManager.currentColorScheme)
//                    return cell
//                }
//            case .movie:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieListTableViewCell {
                    cell.prepareForReuse()
                    cell.prepare(with: movie, colorScheme: csManager.currentColorScheme)
                    return cell
                    }
//            }
//        }
        return UITableViewCell()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let movie = fetchedResultController?.object(at: indexPath) else { return }
            context.delete(movie)
            saveContext()
        }
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //guard let type = movies[indexPath.row].itemType, type == .movie else { return }
        self.selectedMovie = movies[indexPath.row]
        self.performSegue(withIdentifier: "showMovie", sender: nil)
    }
}

extension MovieListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            print("delete")
        case .insert:
            print("insert")
        case .move:
            print("move")
        case .update:
            print("update")
        }
        
        self.updateTableView()
    }
}

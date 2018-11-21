////
////  CDMovieService.swift
////  MovieNight
////
////  Created by Gustavo De Mello Crivelli on 17/11/18.
////  Copyright © 2018 Movile. All rights reserved.
////
//
//import Foundation
//import CoreData
//import UIKit
//
//protocol MovieDataReceiverDelegate {
//    func receive(movieData: [CDMovie])
//}
//
//class CDMovieService: MovieServiceProtocol {
//
//    weak var receiverDelegate: MovieDataReceiverDelegate?
//    var fetchedResultController: NSFetchedResultsController<CDMovie>?
//
//    var appDelegate: AppDelegate {
//        return UIApplication.shared.delegate as! AppDelegate
//    }
//
//    var context: NSManagedObjectContext {
//        return appDelegate.persistentContainer.viewContext
//    }
//
//    func fetchMovies(with filter: String = "", completion: ([CDMovie], Error?) -> Void) {
//        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
//
//        let sortDescriptor = NSSortDescriptor(keyPath: \CDMovie.title, ascending: true)
//
//        // Predicate filters:
//        // [c] -> ignore upper/lowercase
//        // [d] -> diacritico, ignorar acentos
//        let filter = "st"
//        let predicate = NSPredicate(format: "title contains [cd] %@", filter)
//
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        fetchRequest.predicate = predicate
//
//        fetchedResultController = NSFetchedResultsController<CDMovie>(fetchRequest: fetchRequest,
//                                                                      managedObjectContext: context,
//                                                                      sectionNameKeyPath: nil,
//                                                                      cacheName: nil)
//        fetchedResultController?.delegate = self
//        do {
//            try fetchedResultController?.performFetch()
//        }
//        catch {
//            print(error)
//        }
//    }
//
//    func saveContext() {
//    do {
//            if context.hasChanges {
//                try context.save()
//            }
//        } catch {
//            print(error)
//        }
//    }
//}
//
//extension CDMovieService: NSFetchedResultsControllerDelegate {
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
//                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        receiverDelegate?.receive(movieData: controller.fetchedObjects)
//    }
//}

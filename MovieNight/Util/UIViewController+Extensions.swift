//
//  UIViewController+Extensions.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var csManager: ColorSchemeManager {
        return ColorSchemeManager.shared
    }
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error)
        }
    }
}

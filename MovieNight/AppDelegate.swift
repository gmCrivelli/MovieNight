//
//  AppDelegate.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let csManager = ColorSchemeManager.shared
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.tintColor = csManager.currentColorScheme.iconColor
        
        center.delegate = self
        center.getNotificationSettings { (settings) in
            /*
             switch settings.authorizationStatus {
             case .authorized:
             case .denied:
             case .notDetermined:
             case .provisional:
             }*/
        }
        
        let confirmAction = UNNotificationAction(identifier: "confirm", title: "Ok, vou ver 👍", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancelar", options: [])
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.allowInCarPlay, .customDismissAction])
        
        center.setNotificationCategories([category])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Post a notification to update the app if needed
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: UNKeys.colorUpdate)))
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: UNKeys.autoplayUpdate)))
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: UNKeys.dataUpdate)))
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieNight")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError()
            }
        })
        return container
    }()
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // let id = response.notification.request.identifier
        // response.notification.request.content.userInfo["data"]
        
        switch response.actionIdentifier {
        case "confirm":
            break
        case "cancel":
            break
        case UNNotificationDefaultActionIdentifier:
            print("TOCOU NA NOTIFICACAO!")
        case UNNotificationDismissActionIdentifier:
            print("DISMISSOU!")
        default:
            break
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

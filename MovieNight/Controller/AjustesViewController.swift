//
//  AjustesViewController.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 13/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import UIKit

class AjustesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var lblAutoplay: UILabel!
    @IBOutlet weak var lblAjustes: UILabel!
    @IBOutlet weak var segColor: UISegmentedControl!
    @IBOutlet weak var swAutoplay: UISwitch!

    // MARK: - Properties
    let userDefaults = UserDefaults.standard

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return csManager.currentColorScheme.statusBarStyle
    }

    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupFromBundle()
        self.registerForNotifications()
        self.reloadColor()
        self.reloadI18N()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods
    func setupFromBundle() {
        swAutoplay.setOn(userDefaults.bool(forKey: UserDefaults.Keys.autoplay), animated: false)
        segColor.selectedSegmentIndex = userDefaults.integer(forKey: UserDefaults.Keys.color)
    }

    /// Register the VC for notifications, where the UI will have to be updated
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadColor),
                                               name: NSNotification.Name(UNKeys.colorUpdate),
                                               object: nil)
    }

    @objc func reloadColor() {
        csManager.reloadColorScheme()

        self.view.backgroundColor = csManager.currentColorScheme.bgColor

        lblAutoplay.textColor = csManager.currentColorScheme.textColor
        lblAjustes.textColor = csManager.currentColorScheme.textColor
        segColor.tintColor = csManager.currentColorScheme.iconColor
        swAutoplay.tintColor = csManager.currentColorScheme.iconColor

        self.view.window?.tintColor = csManager.currentColorScheme.iconColor

        self.tabBarController?.tabBar.barTintColor = csManager.currentColorScheme.barColor
        self.tabBarController?.tabBar.unselectedItemTintColor = csManager.currentColorScheme.unselectedColor

        setNeedsStatusBarAppearanceUpdate()
    }

    func reloadI18N() {
        self.title = Localization.settings

        self.tabBarController?.toolbarItems?.first?.title = Localization.movies
        self.tabBarController?.toolbarItems?.last?.title = Localization.settings

        lblAjustes.text = Localization.settings
        lblAutoplay.text = Localization.autoplayTrailers
        segColor.setTitle(Localization.light, forSegmentAt: 0)
        segColor.setTitle(Localization.dark, forSegmentAt: 1)
        segColor.setTitle(Localization.napolitan, forSegmentAt: 2)
    }

    // MARK: - IBActions
    @IBAction func autoplayChanged(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: UserDefaults.Keys.autoplay)
    }

    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        userDefaults.set(sender.selectedSegmentIndex, forKey: UserDefaults.Keys.color)
        reloadColor()
    }
}

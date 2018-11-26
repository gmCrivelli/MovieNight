//
//  MovieNightUITests.swift
//  MovieNightUITests
//
//  Created by Gustavo De Mello Crivelli on 25/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

@testable import MovieNight
import XCTest
import FBSnapshotTestCase

class MovieNightUITests: FBSnapshotTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation -
        // required for your tests before they run. The setUp method is a good place to do this.
        recordMode = true
    }

    func testSettingsReloadColor() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        XCTAssertNotNil(storyboard)
        guard let viewC = storyboard.instantiateViewController(
            withIdentifier: String(describing: AjustesViewController.self)) as? AjustesViewController else {
            XCTAssert(false)
            return
        }

        _ = viewC.view
        FBSnapshotVerifyView(viewC.view)
    }
}

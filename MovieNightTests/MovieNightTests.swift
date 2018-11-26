//
//  MovieNightTests.swift
//  MovieNightTests
//
//  Created by Gustavo De Mello Crivelli on 25/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import XCTest
import CoreData
@testable import MovieNight

class MovieNightTests: XCTestCase {

    func testValidMovieTrailer() {
        // Given
        let movie = "Inception"
        let expectation = XCTestExpectation(description: "Fetch movie trailer")

        // When
        REST.trailerUrl(from: movie, onComplete: { _ in
            expectation.fulfill()
        }, onError: { (error) in
            print(error)
        })

        // Then
        wait(for: [expectation], timeout: 5.0)
    }

    func testMovieTrailerNotFound() {
        // Given
        let movie = "Inceptionesqwertyuiop"
        let expectation = XCTestExpectation(description: "Fetch invalid movie trailer")

        // When
        REST.trailerUrl(from: movie, onComplete: { url in
            print(url)
        }, onError: { (error) in
            switch error {
            case .notFound:
                expectation.fulfill()
            default:
                print(error)
            }
        })

        // Then
        wait(for: [expectation], timeout: 5.0)
    }

    func testColorScheme() {
        // Given
        let csManager = ColorSchemeManager.shared
        csManager.saveColorScheme(to: .dark)
        let udColorScheme = UserDefaults.standard.string(forKey: UserDefaults.Keys.color)

        // When
        csManager.saveColorScheme(to: .light)

        // Then
        let udNewScheme = UserDefaults.standard.string(forKey: UserDefaults.Keys.color)
        XCTAssertNotEqual(udColorScheme, udNewScheme, "Color Scheme persistence in User Defaults")
    }
}

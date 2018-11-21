//
//  JMovieService.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 06/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation
import UIKit

protocol MovieServiceProtocol {
    func fetchMovies(completion: ([JMovie], Error?) -> Void)
}

class JMovieService: MovieServiceProtocol {

    func fetchMovies(completion: ([JMovie], Error?) -> Void) {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            guard let movieAsset = NSDataAsset(name: "movies")?.data else { throw CustomErrors.fileNotFound }
            let movies = try decoder.decode([JMovie].self, from: movieAsset)
            completion(movies, nil)
        } catch {
            completion([], error)
        }
    }
}

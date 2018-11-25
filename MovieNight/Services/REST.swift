//
//  REST.swift
//  MovieNight
//
//  Created by Gustavo De Mello Crivelli on 17/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
enum APIError {
    case invalidJson
    case url
    case noResponse
    case noData
    case httpError(code: Int)
    case internalError
    case notFound
}
//swiftlint:enable identifier_name

class REST {
    static let basePath = "https://itunes.apple.com/search?media=movie&entity=movie&term="
    static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        // let configuration = URLSessionConfiguration.ephemeral -> No cookies or session cache
        // let configuration = URLSessionConfiguration.background -> Long downloads in background execution

        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        configuration.timeoutIntervalForResource = 5.0
        configuration.allowsCellularAccess = false
        configuration.httpMaximumConnectionsPerHost = 5

        return configuration
    }()
    static let session = URLSession(configuration: configuration)

    class func trailerUrl(from movieTitle: String, onComplete: @escaping (URL) -> Void,
                          onError: @escaping (APIError) -> Void) {
        guard let url = URL(string: basePath + movieTitle.replacingOccurrences(of: " ", with: "%20")) else {
            onError(.url)
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return onError(.internalError)
            }

            guard let response = response as? HTTPURLResponse else {
                return onError(.noResponse)
            }

            switch response.statusCode {
            case 200...299:
                break
            default:
                return onError(.httpError(code: response.statusCode))
            }

            guard let data = data else {
                return onError(.noData)
            }

            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let results = jsonData["results"] as? [Any], let resultCount = jsonData["resultCount"] as? Int {
                    if resultCount > 0 {
                        if let result = results.first as? [String: Any],
                            let preview = result["previewUrl"] as? String, let previewUrl = URL(string: preview) {
                            return onComplete(previewUrl)
                        }
                        return onError(.invalidJson)
                    } else {
                        return onError(.notFound)
                    }
                }
            } catch {
                return onError(.invalidJson)
            }
        }
        task.resume()
    }
}

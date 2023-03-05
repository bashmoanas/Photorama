//
//  PhotoStore.swift
//  Photorama
//
//  Created by Anas Bashandy on 05/03/2023.
//

import Foundation

/// Responsible for initiating the web service requests.
final class PhotoStore {
    
    /// Creates an instance of URLSession with the default configuration.
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    /// Initiates the web request.
    func fetchInterestingPhotos() {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            if let jsonData = data {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
    
}

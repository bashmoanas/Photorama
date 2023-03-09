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
    func fetchInterestingPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { [self] data, response, error in
            let result = processPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    /// Process the data returned from the `FlickrAPI`
    /// - Parameters:
    ///   - data: the data returned from the `FlickrAPI` or nil
    ///   - error: the error returned from the `FlickrAPI` or nil
    /// - Returns: Decoded array of photos info or error if the `data` was nil.
    private func processPhotosRequest(data: Data?, error: Error?) -> Result<[Photo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
}

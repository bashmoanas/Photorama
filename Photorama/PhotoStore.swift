//
//  PhotoStore.swift
//  Photorama
//
//  Created by Anas Bashandy on 05/03/2023.
//

import UIKit

/// Photo related errors.
enum PhotoError: Error {
    /// This error is thrown in case we are unable to create a valid UIImage from the data returned from the network call.
    case imageCreationError
    
    /// This error is thrown in case an incorrect photo info is passed as argument to the `fetchImage` method.
    case missingImageURL
}

/// Responsible for initiating the web service requests.
final class PhotoStore {
    
    // MARK: - Properties
    
    /// Retrive and save downloaded images.
    private let imageStore: ImageStore
    
    /// Creates an instance of URLSession with the default configuration.
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    // MARK: - Initialization
    
    init(imageStore: ImageStore) {
        self.imageStore = imageStore
    }
    
    /// Initiates the web request.
    func fetchInterestingPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { [self] data, response, error in
            let result = processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    /// Initiates the web request to download a specific image.
    ///
    /// The method checks first for the image in the cache or on the disk.
    /// If the image was saved or cached, we do not initate the network request and we retrieve the previosuly downloaded image.
    /// If the image was not saved before, we download the image.
    /// Once downloaded, we save the image on the disk.
    ///
    /// - Parameters:
    ///   - photo: the photo information that contains the specific URL for our image.
    ///   - completion: Escaping closure to be called once the network call is finished. It either contains an image or will throw a photo error.
    func fetchImage(for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let photoKey = photo.photoID
        
        // Check the image on disk.
        if let image = imageStore.image(forKey: photoKey) {
            // The image was previously downloaded. Great. return it and exit this method
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        // the image was not downloaded before.
        // Check the imageURL is valid
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) { [self] data, response, error in
            let result = processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                // The image was downloaed successfully.
                // Save it on disk.
                imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
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
    
    /// Process the data returned from the photo info request. It returns a valid `UIImage` or a `PhotoError`.
    /// - Parameters:
    ///   - data: the data returned from the photo info request.
    ///   - error: the error returned from the photo infor request.
    /// - Returns: A valid `UIImage` or a `PhotoError` otherwise
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard let imageData = data,
              let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        
        return .success(image)
    }
    
}

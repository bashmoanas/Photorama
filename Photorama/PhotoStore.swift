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
    func fetchInterestingPhotos() async throws -> [Photo] {
        let url = FlickrAPI.interestingPhotosURL
        do {
            let (data, _) = try await session.data(from: url)
            let result = try FlickrAPI.photos(fromJSON: data)
            return result
        } catch {
            throw error
        }
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
    func fetchImage(for photo: Photo) async throws -> UIImage {
        
        let photoKey = photo.photoID
        
        // Check the image on disk.
        if let image = imageStore.image(forKey: photoKey) {
            // The image was previously downloaded. Great. return it and exit this method
            return image
        }
        
        // the image was not downloaded before.
        // Check the imageURL is valid
        guard let photoURL = photo.remoteURL else {
            throw PhotoError.missingImageURL
        }
        
        do {
            let (data, _) = try await session.data(from: photoURL)
            let result = try processImageRequest(data: data)
            imageStore.setImage(result, forKey: photoKey)
            return result
        } catch {
            throw error
        }
    }
    
    /// Process the data returned from the photo info request. It returns a valid `UIImage` or a `PhotoError`.
    /// - Parameters:
    ///   - data: the data returned from the photo info request.
    ///   - error: the error returned from the photo infor request.
    /// - Returns: A valid `UIImage` or a `PhotoError` otherwise
    private func processImageRequest(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw PhotoError.imageCreationError
        }
        return image
    }
}


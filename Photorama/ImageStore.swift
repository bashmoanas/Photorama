//
//  ImageStore.swift
//  Photorama
//
//  Created by Anas Bashandy on 20/03/2023.
//

import UIKit

/// Fetch and caches images.
///
/// To prevent downloading the image each time the user opens the app, the `ImageStore` will cache each downloaded image and save it on the disk. Before downloading any photos, we consult our `ImageStore` instance for any saved images; if it's missing, only then we fetch the image via a network request.
final class ImageStore {
    
    // MARK: - Properties
    
    /// In-memory caching.
    ///
    /// - note: The `NSScache` requires an instance of `NSString` and not a `String`. The methods signature use a `string` to avoid confusion at call site. In the method implementation the `string` is cast as `NSString`
    private let cache = NSCache<NSString, UIImage>()
    
    
    // MARK: - Helper Methods
    
    /// Creates a URL in the documents directory using a specific key
    /// - Parameter key: The unique image id
    /// - Returns: A URL in the documents directory where one image can be saved.
    private func imageURL(forKey key: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectory.first!
        return documentDirectory.appending(path: key)
    }
    
    
    // MARK: - Actions
    
    /// Save the image in in-memory cache and on disk.
    /// - Parameters:
    ///   - image: the image to be cached.
    ///   - key: the unique image id to be able to retrieve the image back.
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // create full URL for image
        let url = imageURL(forKey: key)
        
        // Turn image into JPEG data
        if let data = image.jpegData(compressionQuality: 0.5) {
            // write it to disk
            try? data.write(to: url)
        }
    }
    
    /// Retrieve a cached/saved image.
    /// - Parameter key: the unique image id via which we are able to retrieve the image.
    /// - Returns: the cached image if available, nil otherwise.
    func image(forKey key: String) -> UIImage? {
        // If the image was recently cached, just get it.
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        // The image was not cached recently.
        let url = imageURL(forKey: key)
        
        // So, we need to check if the image was saved to disk or is a new image.
        guard let imageFromDisk = UIImage(contentsOfFile: url.path()) else {
            // It's a new image. Get out of here.
            return nil
        }
        
        // The image was already saved into disk:
        // - cache it.
        cache.setObject(imageFromDisk, forKey: key as NSString)
        // - return it.
        return imageFromDisk
    }
    
    /// Delete the image from the cache/disk.
    /// - Parameter key: the unique image id via which we are able to retrieve the image.
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
}

//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Anas Bashandy on 02/03/2023.
//

import UIKit

class PhotosViewController: UIViewController {
    
    // MARK: - UIViews
    
    /// A temporary image view to download the first picture. After that this will be deleted and replaced with a collection view.
    private let imageView = UIImageView()
    
    /// Instance of the PhotoStore to initiate the network request from this view controller.
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        // Initiate the network request.
        store.fetchInterestingPhotos { [self] photosResult in
            switch photosResult {
            case .success(let photos):
                print("Successfully found \(photos.count) photos")
                if let firstPhoto = photos.first {
                    updateImageView(for: firstPhoto)
                }
            case .failure(let error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
    
    // MARK: - Helper Methods
    
    /// Configure the view controller's main view
    ///
    /// All UI configuration should pass through this method
    ///
    /// - Fix the background color as the view was created programmatically.
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        configureImageView()
    }
    
    /// Configure the navigation bar
    ///
    /// - Add a title
    private func configureNavigationBar() {
        title = "Photorama"
    }
    
    /// Configure the image view
    ///
    /// - Add as a subview
    /// - configure its appearance
    /// - apply its constraints
    private func configureImageView() {
        view.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) { [self] imageResult in
            
            switch imageResult {
            case .success(let image):
                imageView.image = image
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
}

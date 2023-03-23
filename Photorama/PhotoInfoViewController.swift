//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Anas Bashandy on 23/03/2023.
//

import UIKit

/// Displays one photo at a time.
final class PhotoInfoViewController: UIViewController {
    
    // MARK: - UIViews
    
    /// A view that holds a photo.
    private let imageView = UIImageView()
    
    
    // MARK: - Properties
    
    /// The photo info the user tapped on.
    private var photo: Photo
    
    /// The `PhotoStore` to download the image from the `photo` proerty.
    var store: PhotoStore
    
    
    // MARK: - Initialization
    
    init(photo: Photo, store: PhotoStore) {
        self.photo = photo
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchImage(for: photo)
    }
    
    
    // MARK: - Helper Methods
    
    /// Configure the view controller's view.
    ///
    /// All UI updates should path through this method.
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        configureImageView()
        configureNavigationBar()
    }
    
    /// Configure. the navigation bar.
    private func configureNavigationBar() {
        title = photo.title
    }
    
    /// Configure the image view.
    ///
    /// - Add as a subview to the view controller's view.
    /// - Set the content mode.
    /// - Allow accessibility.
    /// - Apply appropriate constraints.
    private func configureImageView() {
        view.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        
        // Accessibility
        imageView.isAccessibilityElement = true
        imageView.isUserInteractionEnabled = false
        imageView.accessibilityLabel = photo.title
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func fetchImage(for photo: Photo) {
        store.fetchImage(for: photo) { result in
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
    
    
    // MARK: - Accessibility
    
    override var isAccessibilityElement: Bool {
        get {
            return true
        }
        set {
            // Ignore
        }
    }
    
}

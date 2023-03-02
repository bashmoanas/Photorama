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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
    
}

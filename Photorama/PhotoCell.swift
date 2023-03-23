//
//  PhotoCell.swift
//  Photorama
//
//  Created by Anas Bashandy on 18/03/2023.
//

import UIKit

/// A custom cell to allow the user to toglle the `isComplete` property of the `ToDo` from the List
final class PhotoCell: UICollectionViewCell {
    
    // MARK: - Views
    
    /// A view holding a photo.
    private let imageView = UIImageView()
    
    /// An activity indicator that animates if the photo is being downloaded and stop animation once the photo is downloaded.
    private let spinner = UIActivityIndicatorView()
    
    
    // MARK: - Properties
    
    /// A description for the photo to be used for accessibility Voice Over.
    var photoDescription: String?
        
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Methods
    
    /// Configure the cell
    ///
    /// This should work as the single path to any UI update for the cell
    private func configureCell() {
        configureImageView()
        configureSpinner()
    }
    
    /// Configures the image view
    ///
    /// - Add as a subview for the content view.
    /// - Set its content mode.
    /// - Apply the appropriate constraints.
    private func configureImageView() {
        contentView.addSubview(imageView)
        
        imageView.contentMode = .scaleToFill
        
        // Add Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    /// Configures the activity indicator.
    ///
    /// - Add as a subview for the image view itself.
    /// - Apply the appropriate constraints.
    private func configureSpinner() {
        imageView.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    
    // MARK: - Actions
    
    /// Configures the cell when there is/isn't a phot to display.
    /// - Parameter image: The photo to be displayed. It will be nil if the photo has not been downloaded yet.
    func configure(with image: UIImage?) {
        guard let imageToDisplay = image else {
            spinner.startAnimating()
            imageView.image = nil
            return
        }
        
        spinner.stopAnimating()
        imageView.image = imageToDisplay
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
    
    override var accessibilityLabel: String? {
        get {
            return photoDescription
        }
        set {
            // Ignore
        }
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return super.accessibilityTraits.union([.image, .button])
        }
        set {
            // Ignore
        }
    }
    
}

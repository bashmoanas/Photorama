//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Anas Bashandy on 02/03/2023.
//

import UIKit

class PhotosViewController: UIViewController {
    
    /// Identifier for the collection view sections.
    enum Section {
        /// Contains all the photos in one section.
        case main
    }
    
    // MARK: - UIViews
    
    /// Manages UI for the photos downloaded from Flickr.
    private lazy var collectionView = makeCollectionView()
    
    /// The data source for the collection view
    private lazy var dataSource = makeDataSource()
    
    /// All the photos downloaded from Flickr.
    var photos = [Photo]()
    
    
    // MARK: - Properties
    
    /// Instance of the PhotoStore to initiate the network request from this view controller.
    var store: PhotoStore!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        // Initiate the network request.
        store.fetchInterestingPhotos { [self] photosResult in
            switch photosResult {
            case .success(let photos):
                self.photos = photos
                applySnapshot()
            case .failure(let error):
                print("Error fetching interesting photos: \(error)")
                self.photos.removeAll()
            }
        }
    }
    
    
    // MARK: - Helper Methods
    
    /// Configure the view controller's main view.
    ///
    /// All UI configuration should pass through this method.
    private func configureView() {
        configureCollectionView()
        configureNavigationBar()
    }
    
    /// Configure the navigation bar.
    ///
    /// - Add a title
    private func configureNavigationBar() {
        title = "Photorama"
    }
    
    /// Use compositional layout to generate a basic grid layout.
    /// - Returns: An instance of `UICollectionViewCompositionalLayout` ready to be used.
    private func generateGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let photoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        photoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalWidth(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: photoItem, count: 4)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    /// Initializes the collection view.
    /// - Returns: A collection view using composotional layout.
    private func makeCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: generateGridLayout())
    }
    
    /// Configure the collection View.
    ///
    /// - Adds the collection view as a subview.
    /// - Assign this view controller to be the collection view's delegate.
    /// - Apply Collection View's Constraints.
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Prepare the `PhotoCell` for use.
    ///
    /// The `PhotoCell` either contains a `Photo` or not.
    /// If it contains a `Photo`, its configuration is done via the collection view's delegate method `willDisplayItem` for performance reasons.
    /// When it doen't contains a `Photo`, a spinner should animate indicating a `Photo` is being downloaded.
    /// - Returns: A configured `PhotoCell`.
    private func registerPhotoCell() -> UICollectionView.CellRegistration<PhotoCell, Photo> {
        return UICollectionView.CellRegistration<PhotoCell, Photo> { cell, indexPath, item in
            cell.configure(with: nil)
        }
    }
    
    /// Prepares the data source for the collection view.
    /// - Returns: An instance of `UICollectionViewDiffableDataSource` with the appropriate section and photo.
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Photo> {
        let photoCellRegistration = registerPhotoCell()
        let dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView) { [self] collectionView, indexPath, photo in
            let cell = collectionView.dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: photo)
            let photo = photos[indexPath.item]
            cell.photoDescription = photo.title
            return cell
        }
        
        return dataSource
    }
    
    /// Apply the current state of data to the view controller's data source at a single point of time.
    /// - Parameter animatingDifferences: whether to animate the data changes or not depending on the situation.
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}


extension PhotosViewController: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        
        // Start downloading the photo for the cell that is about to be displayed.
        store.fetchImage(for: photo) { [self] result in
            
            // The index path for the photo might have changed between the time the request started and finished.
            // So, we get the latest index path
            guard let photoIndex = photos.firstIndex(of: photo),
                  case let .success(image) = result else {
                return
            }
            
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            // Find the photo's cell
            if let cell = collectionView.cellForItem(at: photoIndexPath) as? PhotoCell {
                cell.configure(with: image)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let photoInfoViewController = PhotoInfoViewController(photo: photo, store: store)
        navigationController?.pushViewController(photoInfoViewController, animated: true)
    }
    
}

//
//  Photo.swift
//  Photorama
//
//  Created by Anas Bashandy on 09/03/2023.
//

import Foundation

/// Represent each photo that is returned from the web service request.
struct Photo {
    
    /// The photo title.
    let title: String
    
    /// The URL to the actual photo.
    let remoteURL: URL
    
    /// The photo ID.
    let photoID: String
    
    /// The date taken of the photo.
    let dateTaken: Date
    
}

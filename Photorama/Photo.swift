//
//  Photo.swift
//  Photorama
//
//  Created by Anas Bashandy on 09/03/2023.
//

import Foundation

/// Represent each photo that is returned from the web service request.
struct Photo: Codable {
    
    /// The photo title.
    let title: String
    
    /// The URL to the actual photo.
    let remoteURL: URL
    
    /// The photo ID.
    let photoID: String
    
    /// The date taken of the photo.
    let dateTaken: Date
    
    
    /// Map the key name returned from the API to a convenient property name.
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
    
}

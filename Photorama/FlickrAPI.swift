//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Anas Bashandy on 02/03/2023.
//

import Foundation

/// The end point to hit on the Flickr Server.
enum EndPoint: String {
    
    /// The endpoint to get interesting photos.
    case interestingPhotos = "flickr.interestingness.getList"
}

/// Resposible for knowing and handling all Flickr-related information.
///
/// This includes how to generate the URLs that the Flickr API expects as well as knowing the format of incoming JSON and how to parse that JSON into the relevant model objects.
struct FlickrAPI {
    
}

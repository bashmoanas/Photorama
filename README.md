#  Photorama

A demo project for creating and sending network requests to send and receive data.


## Description

Photorama fetches and parses JSON data from Flickr server using URLSession. It then caches the downloaded images locally, and before making any new requests, it checks if the image was already downloaded to avoid any unecessary network calls.

- The first screen displays the interesting photos in a grid using UICollectionView.
- The user can tap on a photo to navigate to and display this single photo.



![PhotoramaScreenshots 001](https://github.com/bashmoanas/Photorama/assets/34455425/2a7c5e64-a474-40a2-8494-9bfef81fc0f8)



## Architecture

The app is written using the Model View Controller using a store to manage the image caching mechanism:

- The FlickrAPI struct encapsulates all the required information to construct the URL for retrieving interesting photosfrom the Flickr web service. Endpoints are represented as enums, so in the future it is easy to build a new URL for another endpoint by adding another case.
- The PhotoStore struct is responsible for network calls. It currently fetches the photos metadata, and then fetches the image itself. In the future, to avoid having lots of network calls, this struct can be refactored to use generics.


## Note

This project is part of [the iOS Programming: The Big Nerd Ranch Guide](https://bignerdranch.com/books/ios-programming-the-big-nerd-ranch-guide-7th-edition/)

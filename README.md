# TheMovieDB

A simple app that fetches and shows a list of now playing movies using TheMovieDB API.

# Architecture

The app is made using MVVM pattern alongside with the reactive framework RxSwift. 

- RxSwift
- RxCocoa

#### Libraries for testing:
- Quick
- Nimble
- RxTest
- RxBlocking
- Mockingjay

# Caveats

Since this is a tech test there are a few compromises made. Here are some of them:

## Image Caching
Although I've added caching this is only a memory cache. A better solution would be to have a disk-caching, this could be achieved by having a `FileManager` and a `DispatchQueue` to save images on disk asyncronously. This caching mechanism should also be seperated so that it could be expanded to support different types of caching. Also `ImageService` shouldn't really be a singleton.

## Cell sizes
I should have tested the cell sizes are correct when orientation changes, there's no ideal way to do this, an approximation would be to ensure that the delegate method returns the correct cell size given the bounds and orientation.

## Pixel perfection
Cell sizes are not entirely pixel perfect and also the layout of the collection view should be custom in order to support better image size/orientation.

## API Error handling
Better error handling should also exist in order to visually display them. This could be achieved using a set of common errors, alongside with a custom to return the actual API error. With the use of a `Result<T, E: Error>` enum we would be able to return an `Observable<Result<T, E>>` and handle the `error` appropriately.

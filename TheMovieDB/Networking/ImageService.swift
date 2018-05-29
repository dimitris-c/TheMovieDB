//
//  ImageService.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import Foundation
import RxSwift

protocol CachableImageServiceType {
    func saveImage(image: UIImage, for key: String)
    func retrieveImage(for key: String) -> UIImage?
}

protocol ImageServiceType {
    func loadImage(url: URL) -> Observable<UIImage?>
}

class ImageService: ImageServiceType, CachableImageServiceType {

    static let `default` = ImageService()

    private let _imageCache = NSCache<AnyObject, UIImage>()

    private init() {
        _imageCache.totalCostLimit = 20
    }

    func loadImage(url: URL) -> Observable<UIImage?> {
        return self._loadImage(url: url)
    }

    private func _loadImage(url: URL) -> Observable<UIImage?> {
        return Observable.deferred {
            let imageFromCache = self.retrieveImage(for: url.absoluteString)
            if let image = imageFromCache {
                return Observable.just(image)
            }

            return URLSession.shared.rx.data(request: URLRequest(url: url))
                .map { UIImage(data: $0) }
                .do(onNext: { image in
                    if let image = image {
                        self.saveImage(image: image, for: url.absoluteString)
                    }
                })
                .catchErrorJustReturn(nil)
        }
    }

    func saveImage(image: UIImage, for key: String) {
        _imageCache.setObject(image, forKey: key as AnyObject)
    }

    func retrieveImage(for key: String) -> UIImage? {
        return _imageCache.object(forKey: key as AnyObject)
    }
}

//
//  UIImageView+Network.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIImageView {

    func load(url: URL) -> Disposable {
        return ImageService.default.loadImage(url: url).bind(to: base.rx.image)
    }

}

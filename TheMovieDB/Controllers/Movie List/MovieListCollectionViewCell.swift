//
//  MovieListCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListCollectionViewCell: UICollectionViewCell {

    private let disposeBag = DisposeBag()

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!

    func configure(with model: Movie) {

        if let url = URL(string: model.posterPathURLString) {
            self.poster.rx.load(url: url).disposed(by: disposeBag)
        }
        self.title.text = model.title
    }

}

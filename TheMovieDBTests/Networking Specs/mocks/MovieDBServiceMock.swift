//
//  MovieDBServiceMock.swift
//  TheMovieDBTests
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import RxSwift
import RxCocoa
@testable import TheMovieDB

class MovieDBServiceMock: MovieDBService {

    var listReturnValue = Observable<[Movie]>.empty()
    override func getNowPlaying() -> Single<[Movie]> {
        return listReturnValue.asSingle()
    }

    var movieDetailsReturnValue = Observable<Movie>.empty()
    override func getMovieDetails(movieId: Int) -> Single<Movie> {
        return movieDetailsReturnValue.asSingle()
    }

}

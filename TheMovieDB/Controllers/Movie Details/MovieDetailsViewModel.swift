//
//  MovieDetailsViewModel.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//Copyright © 2018 Dimitris C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieDetailsViewModelInputs {
    var loadTrigger: PublishRelay<Void> { get set }
}

protocol MovieDetailsViewModelOutputs {
    var movie: Observable<Movie> { get set }
    var isLoading: Driver<Bool> { get set }
    var alertMessage: Observable<String> { get set }
    //
    var title: Driver<String> { get set }
    var year: Driver<String> { get set }
    var overview: Driver<String> { get set }
    var imageUrl: Driver<URL?> { get set }
}

protocol MovieDetailsViewModelType {
    var inputs: MovieDetailsViewModelInputs { get }
    var outputs: MovieDetailsViewModelOutputs { get }
}

class MovieDetailsViewModel: MovieDetailsViewModelType {
    public var inputs: MovieDetailsViewModelInputs { return self }
    public var outputs: MovieDetailsViewModelOutputs { return self }

    var loadTrigger = PublishRelay<Void>()

    var movie = Observable<Movie>.empty()
    var isLoading = Driver<Bool>.just(false)
    var alertMessage = Observable<String>.empty()

    var title = Driver<String>.empty()
    var year = Driver<String>.empty()
    var overview = Driver<String>.empty()
    var imageUrl = Driver<URL?>.empty()

    private var service: MovieDBService
    private var movieId: Int

    init(movieId: Int, service: MovieDBService) {
        self.movieId = movieId
        self.service = service
        let activity = ActivityIndicator()

        let _alertMessage = PublishSubject<String>()
        self.alertMessage = _alertMessage.asObservable()

        self.movie = loadTrigger
            .flatMapLatest { [movieId, service] _ in
                return service.getMovieDetails(movieId: movieId)
                    .trackActivity(activity)
            }
            .catchError({ error -> Observable<Movie> in
                _alertMessage.onNext(error.localizedDescription)
                return Observable.empty()
            })

        title = self.movie.map { $0.title }.asDriver(onErrorJustReturn: "")
        year = self.movie.map({ movie in
            guard let date = movie.releaseDate else {
                return ""
            }
            return DateFormatter.year.string(from: date)
        }).asDriver(onErrorJustReturn: "")

        overview = self.movie.map { $0.overview }.asDriver(onErrorJustReturn: "")
        imageUrl = self.movie.map { URL(string: $0.backdropPathURLString) }.asDriver(onErrorJustReturn: nil)

        isLoading = activity.asDriver()
    }
}

extension MovieDetailsViewModel: MovieDetailsViewModelInputs, MovieDetailsViewModelOutputs { }

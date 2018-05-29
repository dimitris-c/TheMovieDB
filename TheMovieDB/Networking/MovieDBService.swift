//
//  MovieDBService.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
    case networkError
}

class MovieDBService {

    private let basePath = "https://api.themoviedb.org/3"
    private let apiKey = "a08e472cc41982971dda15f5122ca907"

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func getNowPlaying() -> Single<[Movie]> {
        guard let url = self.url(path: "movie/now_playing") else {
            return Single<[Movie]>.error(ServiceError.networkError)
        }
        let request = URLRequest(url: url)
        return session.rx.data(request: request)
            .map{ [decoder] data throws -> NowPlayingMovies in
                return try decoder.decode(NowPlayingMovies.self, from: data)
            }
            .map { $0.results }
            .catchErrorJustReturn([])
            .asSingle()
    }

    func getMovieDetails(movieId: Int) -> Single<Movie> {
        guard let url = self.url(path: "movie/\(movieId)") else {
            return Single<Movie>.error(ServiceError.networkError)
        }
        let request = URLRequest(url: url)
        return session.rx.data(request: request)
            .map({ [decoder] data -> Movie in
                return try decoder.decode(Movie.self, from: data)
            })
            .asSingle()
    }

    private func url(path: String) -> URL? {
        return URL(string: "\(basePath)/\(path)?api_key=\(apiKey)")
    }

    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        return decoder
    }()

}

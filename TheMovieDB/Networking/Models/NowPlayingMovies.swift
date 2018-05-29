//
//  NowPlayingMovies.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import Foundation

enum NowPlayingMoviesKeys: String, CodingKey {
    case page
    case results
    case totalPages = "total_pages"
}

struct NowPlayingMovies: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NowPlayingMoviesKeys.self)

        self.page = try container.decode(Int.self, forKey: .page)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.results = try container.decode([Movie].self, forKey: .results)
    }
}

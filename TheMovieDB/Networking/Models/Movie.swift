//
//  Movie.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import Foundation

enum MovieKeys: String, CodingKey {
    case id
    case title
    case overview
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
    case voteAverage = "vote_average"
    case releaseDate = "release_date"
    case belongsToCollection = "belongs_to_collection"
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: Date?

    let belongsToCollection: MovieCollection?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.posterPath = try? container.decode(String.self, forKey: .posterPath)
        self.backdropPath = try? container.decode(String.self, forKey: .backdropPath)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.releaseDate = try? container.decode(Date.self, forKey: .releaseDate)
        self.belongsToCollection = try? container.decode(MovieCollection.self, forKey: .belongsToCollection)
    }

    // TODO: The static base url of the images should be handled in a better way as to load the configuration API

    var posterPathURLString: String {
        guard let path = posterPath else { return "" }
        return "https://image.tmdb.org/t/p/w300\(String(describing: path))"
    }

    var backdropPathURLString: String {
        guard let path = backdropPath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(String(describing: path))"
    }

}

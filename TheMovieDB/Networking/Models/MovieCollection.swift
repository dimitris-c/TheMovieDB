//
//  MovieCollection.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import Foundation

enum MovieCollectionKeys: String, CodingKey {
    case id
    case name
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
    case parts
}


struct MovieCollection: Decodable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    let parts: [Movie]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieCollectionKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.posterPath = try? container.decode(String.self, forKey: .posterPath)
        self.backdropPath = try? container.decode(String.self, forKey: .backdropPath)
        self.parts = try? container.decode([Movie].self, forKey: .parts)
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

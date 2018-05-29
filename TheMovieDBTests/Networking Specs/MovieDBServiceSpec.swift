//
//  MovieDBServiceSpec.swift
//  TheMovieDBTests
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Mockingjay
import RxBlocking
@testable import TheMovieDB

class MovieDBServiceSpec: QuickSpec {

    var sut: MovieDBService!

    override func spec() {
        describe("MovieDB Service") {

            beforeEach {
                let session = URLSession(configuration: .ephemeral)
                self.sut = MovieDBService(session: session)
            }

            context("Now Playing") {
                var stub: Data!
                beforeEach {
                    stub = self.json(with: "nowplaying-mock")
                }

                it("should be able to fetch the now playing movies") {
                    self.stub(uri("/3/movie/now_playing"), jsonData(stub))
                    let movies = try! self.sut.getNowPlaying().toBlocking().first()
                    expect(movies).toNot(beNil())
                    expect(movies!.count).to(beGreaterThan(0))

                    // First Result on the mock file
                    let firstResult = movies!.first
                    expect(firstResult!.title).to(equal("Deadpool 2"))
                    expect(firstResult!.posterPath).toNot(beNil())
                    expect(firstResult!.backdropPath).toNot(beNil())
                    expect(firstResult!.releaseDate).toNot(beNil())
                }
            }

            context("Now Playing") {
                var stub: Data!
                beforeEach {
                    stub = self.json(with: "moviedetails-mock")
                }

                it("should be able to fetch a movie details") {
                    let movieId = 383498
                    self.stub(uri("/3/movie/\(movieId)"), jsonData(stub))

                    let result = self.sut.getMovieDetails(movieId: movieId)
                    let movie = try! result.toBlocking().first()
                    expect(movie).toNot(beNil())

                    expect(movie!.title).to(equal("Deadpool 2"))
                    expect(movie!.id).to(equal(movieId))
                    expect(movie!.posterPath).toNot(beNil())
                    expect(movie!.backdropPath).toNot(beNil())
                    expect(movie!.voteAverage).to(equal(8))
                    expect(movie!.releaseDate).toNot(beNil())

                    expect(movie!.belongsToCollection).toNot(beNil())
                    let belongsToCollection = movie!.belongsToCollection!
                    expect(belongsToCollection.name).to(equal("Deadpool Collection"))
                    expect(belongsToCollection.posterPath).toNot(beNil())
                    expect(belongsToCollection.backdropPath).toNot(beNil())

                    expect(belongsToCollection.parts).to(beNil())

                }
            }

        }
    }


    private func json(with path: String) -> Data {
        let path = Bundle(for: type(of: self)).path(forResource: path, ofType: "json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }
}

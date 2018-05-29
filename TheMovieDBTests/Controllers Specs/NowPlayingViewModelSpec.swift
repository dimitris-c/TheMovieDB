//
//  NowPlayingViewModelSpec.swift
//  TheMovieDBTests
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import TheMovieDB

class NowPlayingViewModelSpec: QuickSpec {
    
    override func spec() {
        var testScheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var movieList: NowPlayingMovies!
        var service: MovieDBServiceMock!
        var sut: NowPlayingViewModel!
        beforeEach {
            let session = URLSession(configuration: .default)
            service = MovieDBServiceMock(session: session)
            sut = NowPlayingViewModel(with: service)
            movieList = self.movieListMock()

            testScheduler = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
        }

        afterEach {
            service = nil
            sut = nil
            movieList = nil
            disposeBag = nil
        }

        describe("NowPlayingViewModel") {

            it("should be able to fetch items when load input is triggered") {
                service.listReturnValue = .just(movieList.results)
                testScheduler.createHotObservable([Recorded.next(300, ())])
                    .bind(to: sut.inputs.loadTrigger)
                    .disposed(by: disposeBag)

                let result = testScheduler.start { sut.outputs.items.asObservable() }
                expect(result.events.count).to(equal(1))

                let movies = result.events.first?.value.element
                expect(movies).toNot(beNil())
                expect(movies!.count).to(beGreaterThan(0))

                let model = result.events.first?.value.element?.first

                expect(model).toNot(beNil())
                expect(model!.title).to(equal("Deadpool 2"))
            }

            it("should emmit empty list on network error") {
                let error = NSError(domain: "Test", code: 2, userInfo: nil)
                service.listReturnValue = .error(error)

                testScheduler.createHotObservable([Recorded.next(300, ())])
                    .bind(to: sut.inputs.loadTrigger)
                    .disposed(by: disposeBag)

                sut.outputs.items.asObservable()
                    .subscribe()
                    .disposed(by: disposeBag)

                let result = testScheduler.start { sut.outputs.items.asObservable() }
                expect(result.events.first?.value.element).to(beEmpty())

            }

        }

    }

    private func movieListMock() -> NowPlayingMovies {
        let path = Bundle(for: type(of: self)).path(forResource: "nowplaying-mock", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
        return try! decoder.decode(NowPlayingMovies.self, from: data)
    }
    
}

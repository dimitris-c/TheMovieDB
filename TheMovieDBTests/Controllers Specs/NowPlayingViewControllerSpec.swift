//
//  NowPlayingViewControllerSpec.swift
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
import Mockingjay
@testable import TheMovieDB

class NowPlayingViewControllerSpec: QuickSpec {
    
    override func spec() {
        var sut: NowPlayingViewController!
        var viewModel: NowPlayingViewModel!
        var service: MovieDBServiceMock!
        beforeEach {
            let session = URLSession(configuration: .default)
            service = MovieDBServiceMock(session: session)
            viewModel = NowPlayingViewModel(with: service)
            sut = NowPlayingViewController.initFromStoryboard(name: "Main")
        }

        afterEach {
            service = nil
        }

        describe("before appearance") {
            it("should not have a viewModel assigned") {
                expect(sut).toNot(beNil())
                expect(sut.viewModel).to(beNil())
            }
        }

        describe("on load") {
            beforeEach {
                sut.viewModel = viewModel
                _ = sut.view
            }
            context("collectionView") {
                it("should have a collectionView and provide no items") {
                    expect(sut.collectionView).toNot(beNil())
                    expect(sut.collectionView.numberOfSections).to(equal(1))
                    expect(sut.collectionView.numberOfItems(inSection: 0)).to(equal(0))
                }

                it("should have a delegate") {
                    expect(sut.collectionView.delegate).toNot(beNil())
                }
                it("should have a flow layout") {
                    expect(sut.collectionView.collectionViewLayout).toNot(beNil())
                    expect(sut.collectionView.collectionViewLayout is UICollectionViewFlowLayout).to(beTrue())
                }

                it("should have a refresh control") {
                    expect(sut.collectionView.refreshControl).toNot(beNil())
                }

                it("should have a title") {
                    expect(sut.title).to(equal("Now Playing"))
                }

                context("the flow layout") {
                    it("should be configured with a spacing of 5 pixel") {
                        let flowLayout = sut.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                        expect(flowLayout.minimumLineSpacing).to(equal(5))
                        expect(flowLayout.minimumInteritemSpacing).to(equal(5))
                    }
                }
            }
        }

        describe("on appearance") {
            beforeEach {
                sut.viewModel = viewModel
                _ = sut.view
            }
            it("should start loading data from view model") {
                service.listReturnValue = .just(self.movieListMock().results)

                sut.viewWillAppear(true)
                waitUntil(action: { (done) in
                    _ = sut.viewModel?.outputs.items.asObservable().subscribe(onNext: { items in
                        done()
                    })
                })

                expect(sut.collectionView.numberOfItems(inSection: 0)).to(beGreaterThan(0))
            }
        }

        describe("cell sizes") {
            it("provides the correct size when the layout asked") {
                _ = sut.view
                sut.collectionView.frame = CGRect(x: 0, y: 0, width: 375, height: 600)

                let layout = sut.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let layoutDelegate = sut as UICollectionViewDelegateFlowLayout
                let indexPath = IndexPath(item: 0, section: 0)

                let cellSize = layoutDelegate.collectionView!(sut.collectionView, layout: layout, sizeForItemAt: indexPath)
                expect(cellSize).to(equal(CGSize(width: 185.0, height: 196.0)))
            }
        }

        describe("movie list items") {
            beforeEach {
                sut.viewModel = viewModel
                _ = sut.view
            }
            it("should configure the cells with the given model correctly") {
                let results = self.movieListMock().results
                service.listReturnValue = .just(results)

                let firstModel = results.first
                expect(firstModel).toNot(beNil())

                self.stub(uri(firstModel!.posterPath!), jsonData(self.mockImage()))

                sut.viewWillAppear(true)
                waitUntil(action: { (done) in
                    _ = sut.viewModel?.outputs.items.asObservable().subscribe(onNext: { items in
                        done()
                    })
                })

                waitUntil(action: { done in
                    sut.collectionView.performBatchUpdates(nil, completion: { _ in
                        done()
                    })
                })

                let indexPath = IndexPath(item: 0, section: 0)
                let cell = sut.collectionView.cellForItem(at: indexPath) as! MovieListCollectionViewCell
                expect(cell).toNot(beNil())
                expect(cell.title.text).to(equal("Deadpool 2"))
                expect(cell.poster.image).toEventuallyNot(beNil())
            }
        }


    }

    private func mockImage() -> Data {
        let path = Bundle(for: type(of: self)).path(forResource: "mock-image", ofType: "png")!
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }

    private func movieListMock() -> NowPlayingMovies {
        let path = Bundle(for: type(of: self)).path(forResource: "nowplaying-mock", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
        return try! decoder.decode(NowPlayingMovies.self, from: data)
    }
    
}

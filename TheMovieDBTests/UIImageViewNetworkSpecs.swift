//
//  UIImageViewNetworkSpecs.swift
//  TheMovieDBTests
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Mockingjay
@testable import TheMovieDB

class UIImageView_RxTests: QuickSpec {

    override func spec() {

        describe("UIImageView+Network") {
            it("should be able to load and image") {
                let sut = UIImageView()
                let url = URL(string: "https://www.google.com/an-image.png")!
                let mockImage = self.mockImage()
                self.stub(uri("/an-image.png"), http(200, headers: nil, download: .content(mockImage)))
                _ = sut.rx.load(url: url)
                expect(sut.image).toEventuallyNot(beNil())
            }
        }

    }

    private func mockImage() -> Data {
        let path = Bundle(for: type(of: self)).path(forResource: "mock-image", ofType: "png")!
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }

}

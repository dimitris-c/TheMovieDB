//
//  ImageServiceSpec.swift
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

class ImageServiceSpec: QuickSpec {
    
    override func spec() {

        describe("ImageService") {
            it("should be able to load a UIImage") {
                let imageUrl: String = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_120x44dp.png"
                let sut = ImageService.default
                let mockImage = self.mockImageData()
                self.stub(uri(imageUrl), http(200, headers: nil, download: .content(mockImage)))
                let url = URL(string: imageUrl)!
                let result = try! sut.loadImage(url: url).toBlocking().toArray()
                expect(result).toNot(beEmpty())
            }

            it("should return nil on error") {
                let imageUrl: String = "https://www.google.com/images/branding/googlelogo/2x/g.png"
                let sut = ImageService.default
                let url = URL(string: imageUrl)!
                self.stub(uri(imageUrl), http(404, headers: nil, download: .noContent))
                let result = try! sut.loadImage(url: url).toBlocking().toArray()
                let image = result.compactMap { $0 }.first
                expect(image).to(beNil())
            }

            context("caching") {
                it("should cache images") {
                    let sut = ImageService.default
                    let image = UIImage(data: self.mockImageData())!
                    sut.saveImage(image: image, for: "aUrlKey")
                    let cachedImage = sut.retrieveImage(for: "aUrlKey")
                    expect(cachedImage).toNot(beNil())
                }

                it("should be able to cache image when loading an image") {
                    let imageUrl: String = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_120x44dp.png"
                    let sut = ImageService.default
                    let url = URL(string: imageUrl)!
                    let mockImage = self.mockImageData()
                    self.stub(uri(imageUrl), http(200, headers: nil, download: .content(mockImage)))
                    let result = try! sut.loadImage(url: url).toBlocking().toArray()
                    let image = result.compactMap { $0 }.first
                    expect(image).toNot(beNil())
                    let cachedImage = sut.retrieveImage(for: imageUrl)
                    expect(cachedImage).toNot(beNil())
                }
            }
        }

    }

    private func mockImageData() -> Data {
        let path = Bundle(for: type(of: self)).path(forResource: "mock-image", ofType: "png")!
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }

}

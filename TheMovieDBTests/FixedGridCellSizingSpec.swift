//
//  FixedGridCellSizingSpec.swift
//  TheMovieDBTests
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import XCTest
import Nimble
import Quick
@testable import TheMovieDB

class FixedGridCellSizingTests: QuickSpec {

    override func spec() {

        describe("FixedGrid Cell Sizing") {
            it("should return the correct size for the given parameters") {
                let sizing = FixedGridCellSizing(rows: 2, cols: 2)
                let size = sizing.size(withContainerSize: CGSize(width: 100, height: 100),
                                       spacing: 2,
                                       insets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
                let expectedSize = CGSize(width: 48, height: 48)
                expect(size).to(equal(expectedSize))
            }
        }

    }

}

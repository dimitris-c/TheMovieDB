//
//  ActivityIndicatorSpec.swift
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

class ActivityIndicatorSpec: QuickSpec {

    override func spec() {
        var sut: ActivityIndicator!
        var scheduler: TestScheduler!

        describe("Activity Indicator") {
            beforeEach {
                sut = ActivityIndicator()
                scheduler = TestScheduler(initialClock: 0)
            }

            it("should track activity of an observable") {

                let observer = scheduler.createObserver(Bool.self)
                let activityObserver = scheduler.createObserver(Bool.self)

                let observable = scheduler.createHotObservable([
                    next(250, true),
                    next(500, true),
                    next(750, true),
                    next(1750, true)
                    ])

                _ = observable.trackActivity(sut).subscribe(observer)

                scheduler.scheduleAt(0, action: {
                    let isLoading = sut.asDriver()
                    _ = isLoading.asObservable().subscribe(activityObserver)
                })

                scheduler.start()

                let results = observer.events.map { $0.value.element! }
                let activityResults = activityObserver.events.map { $0.value.element! }

                expect(results).to(equal([true, true, true, true]))
                expect(activityResults).to(equal([true, false]))
            }

            it("should false when observable errors") {
                let observer = scheduler.createObserver(Bool.self)
                let activityObserver = scheduler.createObserver(Bool.self)

                let observable = scheduler.createHotObservable([
                    next(250, true),
                    error(500, NSError(domain: "", code: 0, userInfo: nil))
                    ])

                _ = observable.trackActivity(sut).subscribe(observer)

                scheduler.scheduleAt(0, action: {
                    let isLoading = sut.asDriver()
                    _ = isLoading.asObservable().subscribe(activityObserver)
                })

                scheduler.start()

                let results = observer.events.map { $0.value.element ?? false }
                let activityResults = activityObserver.events.map { $0.value.element! }

                expect(results).to(equal([true, false]))
                expect(activityResults).to(equal([true, false]))
            }

        }

    }
}

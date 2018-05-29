//
//  TrackActivity.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import RxSwift
import RxCocoa

class ActivityIndicator: SharedSequenceConvertibleType {
    typealias E = Bool
    typealias SharingStrategy = DriverSharingStrategy

    private var _lock = NSRecursiveLock()
    private var _activity = BehaviorSubject<Bool>(value: false)
    private var _loading: SharedSequence<SharingStrategy, Bool>

    init() {
        _loading = _activity.asDriver(onErrorJustReturn: false).distinctUntilChanged()
    }

    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
        return _loading
    }

    fileprivate func track<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return source.asObservable().do(onNext: { _ in
            self.stopTracking()
        }, onError: { _ in
            self.stopTracking()
        }, onCompleted: {
            self.stopTracking()
        }, onSubscribe: subscribed)
    }

    private func subscribed() {
        _lock.lock()
        _activity.onNext(true)
        _lock.unlock()
    }

    private func stopTracking() {
        _lock.lock()
        _activity.onNext(false)
        _lock.unlock()
    }

}

extension ObservableConvertibleType {
    func trackActivity(_ activity: ActivityIndicator) -> Observable<E> {
        return activity.track(self)
    }
}

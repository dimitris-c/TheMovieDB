//
//  NowPlayingViewModel.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//Copyright © 2018 Dimitris C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NowPlayingViewModelInputs {
    var loadTrigger: PublishRelay<Void> { get set }
}

protocol NowPlayingViewModelOutputs {
    var items: Driver<[Movie]> { get set }
    var isLoading: Driver<Bool> { get set }
    var title: Driver<String> { get set }
}

protocol NowPlayingViewModelType {
    var inputs: NowPlayingViewModelInputs { get }
    var outputs: NowPlayingViewModelOutputs { get }
}

class NowPlayingViewModel: NowPlayingViewModelType {
    public var inputs: NowPlayingViewModelInputs { return self }
    public var outputs: NowPlayingViewModelOutputs { return self }

    var loadTrigger: PublishRelay<Void> = PublishRelay<Void>()

    var items = Driver<[Movie]>.empty()
    var isLoading = Driver<Bool>.just(false)
    var title = Driver<String>.just("Now Playing")

    private var service: MovieDBService

    init(with service: MovieDBService) {
        self.service = service

        self.items = loadTrigger.asObservable()
            .flatMapLatest { _ in
                return service.getNowPlaying()
            }
            .asDriver(onErrorJustReturn: [])
        
    }

}

extension NowPlayingViewModel: NowPlayingViewModelInputs, NowPlayingViewModelOutputs { }

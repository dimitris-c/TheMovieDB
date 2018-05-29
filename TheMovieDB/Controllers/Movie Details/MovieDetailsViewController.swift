//
//  MovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MovieDetailsViewController: UIViewController, StoryboardInitializable {

    private var disposeBag = DisposeBag()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieTitle: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieOverview: UILabel!

    var viewModel: MovieDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBindings()
    }

    private func setupBindings() {
        guard let viewModel = viewModel else {
            // TODO: Handle error or investigate why this might fail
            return
        }

        viewModel.outputs.title.drive(self.rx.title).disposed(by: disposeBag)

        // This could be in an extension of UIViewController+Rx
        let willAppear = self.rx.methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { _ in }.take(1).asDriver(onErrorJustReturn: ())

        willAppear
            .asObservable()
            .bind(to: viewModel.inputs.loadTrigger)
            .disposed(by: disposeBag)

        viewModel.outputs.isLoading.drive(activityIndicator.rx.isAnimating).disposed(by: disposeBag)
        viewModel.outputs.alertMessage
            .subscribe(onNext: { [weak self] in self?.presentAlert(message: $0) })
            .disposed(by: disposeBag)

        viewModel.outputs.title.drive(movieTitle.rx.text).disposed(by: disposeBag)
        viewModel.outputs.year.drive(movieYear.rx.text).disposed(by: disposeBag)
        viewModel.outputs.overview.drive(movieOverview.rx.text).disposed(by: disposeBag)

        viewModel.outputs.imageUrl.map { $0 }.asObservable().subscribe(onNext: { [movieImage, disposeBag] url in
            guard let url = url else { return }
            movieImage?.rx.load(url: url).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
    }

    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController?.present(alertController, animated: true, completion: nil)
    }
}


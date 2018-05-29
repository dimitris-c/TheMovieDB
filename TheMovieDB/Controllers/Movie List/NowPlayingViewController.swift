//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NowPlayingViewController: UIViewController, StoryboardInitializable {

    @IBOutlet weak var collectionView: UICollectionView!
    private var disposeBag = DisposeBag()

    var viewModel: NowPlayingViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupBindings()
    }

    private func setupUI() {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 5
        flow.minimumInteritemSpacing = 5
        self.collectionView.delegate = self
        self.collectionView?.collectionViewLayout = flow
        self.collectionView?.refreshControl = UIRefreshControl()
    }

    private func setupBindings() {
        guard let viewModel = viewModel,
            let collectionView = self.collectionView,
            let refreshControl = collectionView.refreshControl else {
            // TODO: Handle error or investigate why this might fail
            return
        }

        viewModel.outputs.title.drive(self.rx.title).disposed(by: disposeBag)

        // This could be in an extension of UIViewController+Rx
        let willAppear = self.rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in }.take(1).asDriver(onErrorJustReturn: ())

        let refresh = refreshControl.rx.controlEvent(.valueChanged).asDriver()

        Driver.merge(willAppear, refresh)
            .asObservable()
            .bind(to: viewModel.inputs.loadTrigger)
            .disposed(by: disposeBag)


        viewModel.outputs.items.drive(collectionView.rx.items(cellIdentifier: "MovieListCollectionViewCell", cellType: MovieListCollectionViewCell.self)) { row, model, cell in
            cell.configure(with: model)
        }.disposed(by: disposeBag)

        collectionView.rx.modelSelected(Movie.self).subscribe(onNext: { [weak self] movie in
            self?.showMovieDetails(movieId: movie.id)
        }).disposed(by: disposeBag)

        viewModel.outputs.isLoading
            .asObservable()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    private func showMovieDetails(movieId: Int) {
        let viewModel = MovieDetailsViewModel(movieId: movieId, service: MovieDBService(session: .shared))
        let viewController = MovieDetailsViewController.initFromStoryboard()
        viewController.viewModel = viewModel
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

extension NowPlayingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            let sizing = FixedGridCellSizing(rows: 3, cols: 2)
            return sizing.size(withContainerSize: collectionView.frame.size,
                               spacing: flow.minimumInteritemSpacing,
                               insets: flow.sectionInset)
        }
        return CGSize.zero
    }
}

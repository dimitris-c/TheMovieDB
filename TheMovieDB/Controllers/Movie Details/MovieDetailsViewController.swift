//
//  MovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, StoryboardInitializable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieTitle: UILabel!

    @IBOutlet weak var movieOverview: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


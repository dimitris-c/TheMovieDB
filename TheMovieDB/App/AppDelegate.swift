//
//  AppDelegate.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)

        let viewModel = NowPlayingViewModel(with: MovieDBService(session: .shared))
        let viewController = NowPlayingViewController.initFromStoryboard(name: "Main")
        viewController.viewModel = viewModel
        let rootViewController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = rootViewController

        self.window?.makeKeyAndVisible()

        return true
    }


}


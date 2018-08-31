//
//  AppDelegate.swift
//  Movies
//
//  Created by Petra Cvrljevic on 22/08/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = setup()
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setup() -> [UINavigationController] {
        let topRatedMoviesVC = MoviesViewController()
        topRatedMoviesVC.navigationItem.title = "Top rated movies"
        topRatedMoviesVC.type = MovieType.TopRated
        let navTopRated = UINavigationController(rootViewController: topRatedMoviesVC)
        navTopRated.tabBarItem.title = "Top rated"
        let popularMovieVC = MoviesViewController()
        popularMovieVC.navigationItem.title = "Popular movies"
        popularMovieVC.type = MovieType.Popular
        let navPopular = UINavigationController(rootViewController: popularMovieVC)
        navPopular.tabBarItem.title = "Popular"
        let controllers = [navTopRated, navPopular]
        return controllers
    }
}

enum MovieType {
    case TopRated
    case Popular
}

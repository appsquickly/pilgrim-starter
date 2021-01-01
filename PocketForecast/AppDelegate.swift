////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


import UIKit
import PilgrimDI
import ICLoader

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    @Assembled var cityRepo: CityRepository
    @Assembled var rootViewController: RootViewController

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        ICLoader.setImageName("cloud_icon.png")
        ICLoader.setLabelFontName(UIFont.applicationFontOfSize(size: 10).fontName)

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.applicationFontOfSize(size: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()

        let selectedCity: String! = cityRepo.loadSelectedCity()
        if selectedCity == nil {
            rootViewController.showCitiesListController()
        }
        return true
    }


}


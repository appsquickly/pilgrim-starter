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

    @Assembled var assembly: ApplicationAssembly
    @Assembled var cityRepo: CityRepository
    @Assembled var rootViewController: RootViewController

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        ICLoader.setImageName("cloud_icon.png")
        ICLoader.setLabelFontName(UIFont.applicationFontOfSize(size: 10).fontName)

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.applicationFontOfSize(size: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        window = assembly.window()
        window?.makeKeyAndVisible()

        if (cityRepo.loadSelectedCity() == nil) {
            rootViewController.showCitiesListController()
        }
        return true
    }
}


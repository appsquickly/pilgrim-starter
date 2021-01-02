/*
 The MIT License (MIT)

 Copyright (c) 2016-2020 The Contributors

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import PilgrimDI

class ApplicationAssembly: PilgrimAssembly {

    //-------------------------------------------------------------------------------------------
    // MARK: - Bootstrapping
    //-------------------------------------------------------------------------------------------

    /*
     * These are modules - assemblies collaborate to provide components to this one.  At runtime you
     * can instantiate Typhoon with any assembly tha satisfies the module interface.
     */
    private(set) var coreComponents: CoreComponents = CoreComponents()
    private(set) var themeAssembly: ThemeAssembly = ThemeAssembly()

    override func makeBindings() {
        super.makeBindings()
        makeInjectable(rootViewController, byType: RootViewController.self)
        importBindings(coreComponents, themeAssembly)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Main Assembly
    //-------------------------------------------------------------------------------------------

    func window() -> UIWindow {
        shared(UIWindow(frame: UIScreen.main.bounds)) { [self] (window: UIWindow) in
            window.rootViewController = rootViewController()
        }
    }

    func rootViewController() -> RootViewController {
        shared(RootViewController(mainContentViewController: weatherReportController(), assembly: self))
    }

    func citiesListController() -> CitiesListViewController {
        objectGraph(CitiesListViewController(cityDao: coreComponents.cityRepository(),
                theme: themeAssembly.currentTheme())) { (controller: CitiesListViewController) in
            controller.assembly = self
        }
    }

    func weatherReportController() -> WeatherReportViewController {
        objectGraph(WeatherReportViewController(view: weatherReportView(),
                weatherClient: coreComponents.weatherClient(), weatherReportRepo: coreComponents.weatherReportRepository(),
                cityRepo: coreComponents.cityRepository(), assembly: self))
    }

    func weatherReportView() -> WeatherReportView {
        objectGraph(WeatherReportView(frame: CGRect.zero)) { [self] (view: WeatherReportView) in
            view.theme = themeAssembly.currentTheme()
        }
    }

    /**
     * Here's an example of property injection, where we inject dependencies in the configuration closure, after the
     * instance has been instantiated.
     * In general, favor initializer injection over property injection.
     */
    func addCityViewController() -> AddCityViewController {
        objectGraph(AddCityViewController(nibName: "AddCity", bundle: Bundle.main)) { [self]
            (controller: AddCityViewController) in

            controller.cityDao = coreComponents.cityRepository()
            controller.weatherClient = coreComponents.weatherClient()
            controller.theme = themeAssembly.currentTheme()
            controller.rootViewController = rootViewController()
        }
    }

}

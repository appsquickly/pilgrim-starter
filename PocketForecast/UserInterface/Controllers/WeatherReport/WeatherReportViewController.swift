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

import UIKit
import ICLoader


class WeatherReportViewController: UIViewController {

    var weatherReportView : WeatherReportView {
        get {
            view as! WeatherReportView
        }
        set {
            view = newValue
        }
    }
    
    private(set) var weatherClient : WeatherClient
    private(set) var weatherReportDao : WeatherReportRepository
    private(set) var cityDao : CityRepository
    private(set) var assembly : ApplicationAssembly
    
    private var cityName : String?
    private var weatherReport : PocketForecast?
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    
    init(view: WeatherReportView, weatherClient : WeatherClient, weatherReportRepo: WeatherReportRepository,
         cityRepo: CityRepository, assembly : ApplicationAssembly) {
        
        self.weatherClient = weatherClient
        self.weatherReportDao = weatherReportRepo
        self.cityDao = cityRepo
        self.assembly = assembly
            
        super.init(nibName: nil, bundle: nil)
        
        weatherReportView = view
                    
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Overridden Methods
    //-------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.isNavigationBarHidden = true

        if let cityName = cityDao.loadSelectedCity() {
            self.cityName = cityName
            if let weatherReport = weatherReportDao.getReport(cityName: cityName) {
                self.weatherReport = weatherReport
                weatherReportView.weatherReport = self.weatherReport
            }
            else  {
                refreshData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if cityName != nil {
            
            let cityListButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(WeatherReportViewController.presentMenu))
            cityListButton.tintColor = .white
            
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(WeatherReportViewController.refreshData))
            refreshButton.tintColor = .white
            
            weatherReportView.toolbar.items = [
                cityListButton,
                space,
                refreshButton
            ]
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------

    @objc private func refreshData() {
        ICLoader.present()

        weatherClient.loadWeatherReportFor(city: cityName!)
            .then { weatherReport in
                self.weatherReportView.weatherReport = weatherReport
                ICLoader.dismiss()
            }
            .catch { error in
                ICLoader.dismiss()
            }
    }
    
    @objc private func presentMenu() {
        assembly.rootViewController().toggleSideViewController()
    }
}

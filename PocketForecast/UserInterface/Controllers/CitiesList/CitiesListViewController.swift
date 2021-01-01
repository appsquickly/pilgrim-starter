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

import Foundation
import UIKit

class CitiesListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, Themeable {
    
    let celsiusSegmentIndex = 0
    let fahrenheitSegmentIndex = 1
    
    // Injected properties
    var cityDao : CityRepository!
    public var theme : Theme!
    var assembly : ApplicationAssembly!
    
    
    // Interface Builder injected properties
    @IBOutlet var citiesListTableView : UITableView!
    @IBOutlet var temperatureUnitsControl : UISegmentedControl!
    
    var cities : Array<String>?
    
    init(cityDao : CityRepository, theme : Theme) {
        super.init(nibName: "CitiesList", bundle: Bundle.main)
        self.cityDao = cityDao
        self.theme = theme
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        title = "Pocket Forecast"
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CitiesListViewController.addCity))
        citiesListTableView.isEditing = true
        temperatureUnitsControl.addTarget(self, action: #selector(CitiesListViewController.saveTemperatureUnitPreference), for: .valueChanged)
        if Temperature.defaultUnits() == TemperatureUnits.Celsius {
            temperatureUnitsControl.selectedSegmentIndex = celsiusSegmentIndex
        }
        else {
            temperatureUnitsControl.selectedSegmentIndex = fahrenheitSegmentIndex
        }
        applyTheme()
    }
    

    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        refreshCitiesList()
        if let cityName = cityDao.loadSelectedCity(), let cities = cities {
            if let index = cities.firstIndex(of: cityName) {
                let indexPath = IndexPath(row: index, section: 0)
                citiesListTableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cities = cities {
            return cities.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseId = "Cities"
        let cell : CityTableViewCell
        if let dequeued = tableView.dequeueReusableCell(withIdentifier: reuseId) as? CityTableViewCell {
            cell = dequeued
        } else {
            cell = CityTableViewCell(style: .default, reuseIdentifier: reuseId)
        }
        cell.selectionStyle = .gray
        cell.cityLabel.backgroundColor = .clear
        cell.cityLabel.font = UIFont.applicationFontOfSize(size: 16)
        cell.cityLabel.textColor = .darkGray
        cell.cityLabel.text = cities![indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName : String = cities![indexPath.row]
        cityDao.saveCurrentlySelectedCity(cityName: cityName)
        assembly.rootViewController().dismissCitiesListController()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let city = cities![indexPath.row]
            cityDao.deleteCity(name: city)
            refreshCitiesList()
        }
    }

    @objc private func addCity() {
        assembly.rootViewController().showAddCitiesController()
    }
    
    private func refreshCitiesList() {
        cities = cityDao.listAllCities()
        citiesListTableView.reloadData()
    }
    
    @objc private func saveTemperatureUnitPreference() {
        if temperatureUnitsControl.selectedSegmentIndex == celsiusSegmentIndex {
            Temperature.setDefaultUnits(units: TemperatureUnits.Celsius)
        }
        else {
            Temperature.setDefaultUnits(units: TemperatureUnits.Fahrenheit)
        }
    }
    
    private func applyTheme() {
        temperatureUnitsControl.tintColor = theme.controlTintColor
        navigationController!.navigationBar.tintColor = .white
        navigationController!.navigationBar.barTintColor = theme.navigationBarColor
    }
}

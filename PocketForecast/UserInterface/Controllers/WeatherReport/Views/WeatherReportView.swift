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

import Foundation
import UIKit

class WeatherReportView : UIView, UITableViewDelegate, UITableViewDataSource, Themeable {
    
    private var backgroundView : UIImageView!
    private var cityNameLabel : UILabel!
    private var conditionsDescriptionLabel : UILabel!
    private var conditionsIcon : UIImageView!

    private var temperatureLabelContainer : UIView!
    private var temperatureLabel : UILabel!
    
    private var lastUpdateLabel : UILabel!
    private var tableView : UITableView!
    
    var toolbar : UIToolbar!
    
    var weatherReport : PocketForecast? {
        willSet(weatherReport) {
            if let weatherReport = weatherReport {
                tableView.isHidden = false
                conditionsIcon.isHidden = false
                temperatureLabelContainer.isHidden = false
                tableView.reloadData()
                cityNameLabel.text = weatherReport.cityDisplayName
                temperatureLabel.text = weatherReport.currentConditions.temperature!.asShortStringInDefaultUnits()
                conditionsDescriptionLabel.text = weatherReport.currentConditions.longSummary()
                lastUpdateLabel.text = "Updated \(weatherReport.reportDateAsString())"

            }
        }
    }
    
    var theme : Theme! {
        willSet(theme) {
            DispatchQueue.main.async() {
                self.toolbar.barTintColor = theme.forecastTintColor
                self.backgroundView.image = UIImage(named: theme.backgroundResourceName)
                self.tableView.reloadData()
            }
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        
        initBackgroundView()
        initCityNameLabel()
        initConditionsDescriptionLabel()
        initConditionsIcon()
        initTemperatureLabel()
        initTableView()
        initToolbar()
        initLastUpdateLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Overridden methods
    //-------------------------------------------------------------------------------------------

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds.insetBy(dx: -10, dy: -10)

        cityNameLabel.frame = CGRect(x: 0, y: height / 6, width: width, height: 40)
        conditionsDescriptionLabel.frame = CGRect(x: 0, y: cityNameLabel.y + 30, width: width, height: 50)

        conditionsIcon.frame = CGRect(x: width / 2 - 125, y: conditionsDescriptionLabel.y + 53, width: 130, height: 120)
        temperatureLabelContainer.frame = CGRect(x: width / 2 + 15, y: conditionsIcon.y + 12, width: 88, height: 88)

        var bottomOffset = frame.size.height
        if #available(iOS 11.0, *) {
            bottomOffset -= safeAreaInsets.bottom
        }
        toolbar.frame = CGRect(x: 0, y: bottomOffset - toolbar.height, width: width, height: toolbar.height)
        tableView.frame = CGRect(x: 0, y: toolbar.frame.origin.y - 150, width: width, height: 150)
        lastUpdateLabel.frame = toolbar.bounds
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate & UITableViewDataSource
    //-------------------------------------------------------------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "weatherForecast"
        var cell : ForecastTableViewCell
        if let dequeueCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ForecastTableViewCell {
            cell = dequeueCell
        } else {
            cell = ForecastTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        }
        
        if let weatherReport = weatherReport, weatherReport.forecast.count > indexPath.row {
            let forecastConditions : ForecastConditions = weatherReport.forecast[indexPath.row]
            cell.dayLabel.text = forecastConditions.longDayOfTheWeek()
            
            if let low = forecastConditions.low {
                cell.lowTempLabel.text = low.asShortStringInDefaultUnits()
            }
            
            if let high = forecastConditions.high {
                cell.highTempLabel.text = high.asShortStringInDefaultUnits()
            }
            
            cell.conditionsIcon.image = UIImage(named: "icon_sunny")
            cell.backgroundView?.backgroundColor = colorForRow(row: indexPath.row)
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       cell.backgroundColor = .clear
    }
  
        
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------
    
    private func initBackgroundView() {
        backgroundView = UIImageView(frame: .zero)
        backgroundView.contentMode = .scaleToFill
        addSubview(backgroundView)
    }
    
    private func initCityNameLabel() {
        cityNameLabel = UILabel(frame: .zero)
        cityNameLabel.font = UIFont.applicationFontOfSize(size: 35)
        cityNameLabel.textColor = UIColor(hex: 0xf9f7f4)
        cityNameLabel.backgroundColor = .clear
        cityNameLabel.textAlignment = .center
        addSubview(cityNameLabel)
    }
    
    private func initConditionsDescriptionLabel() {
        conditionsDescriptionLabel = UILabel(frame: .zero)
        conditionsDescriptionLabel.font = UIFont.applicationFontOfSize(size: 16)
        conditionsDescriptionLabel.textColor = UIColor(hex: 0xf9f7f4)
        conditionsDescriptionLabel.backgroundColor = .clear
        conditionsDescriptionLabel.textAlignment = .center
        conditionsDescriptionLabel.numberOfLines = 0
        addSubview(conditionsDescriptionLabel)
    }
    
    private func initConditionsIcon() {
        conditionsIcon = UIImageView(frame: .zero)
        conditionsIcon.image = UIImage(named: "icon_cloudy")
        conditionsIcon.isHidden = true
        addSubview(conditionsIcon)
    }
    
    private func initTemperatureLabel() {
        temperatureLabelContainer = UIView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        addSubview(temperatureLabelContainer)
        
        let labelBackground = UIImageView(frame: temperatureLabelContainer.bounds)
        labelBackground.image = UIImage(named: "temperature_circle")
        temperatureLabelContainer.addSubview(labelBackground)
        
        temperatureLabel = UILabel(frame: temperatureLabelContainer.bounds)
        temperatureLabel.font = UIFont.temperatureFontOfSize(size: 35)
        temperatureLabel.textColor = UIColor(hex: 0x7f9588)
        temperatureLabel.backgroundColor = .clear
        temperatureLabel.textAlignment = .center
        temperatureLabelContainer.addSubview(temperatureLabel)

        temperatureLabelContainer.isHidden = true
    }
    
    private func initTableView() {
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = false
        tableView.isHidden = true
        addSubview(tableView)
    }
    
    private func initToolbar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        addSubview(toolbar)
    }
    
    private func initLastUpdateLabel() {
        lastUpdateLabel = UILabel(frame: .zero)
        lastUpdateLabel.font = UIFont.applicationFontOfSize(size: 12)
        lastUpdateLabel.textColor = UIColor(hex: 0xf9f7f4)
        lastUpdateLabel.backgroundColor = .clear
        lastUpdateLabel.textAlignment = .center
        toolbar.addSubview(lastUpdateLabel)
    }
    
    private func colorForRow(row : Int) -> UIColor {
        switch (row) {
        case 0:
            return theme.forecastTintColor.withAlphaComponent(0.55)
        case 1:
            return theme.forecastTintColor.withAlphaComponent(0.75)
        default:
            return theme.forecastTintColor.withAlphaComponent(0.95)
        }
    }
}

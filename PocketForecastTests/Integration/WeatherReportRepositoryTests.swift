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
import XCTest
@testable import PocketForecast

class WeatherReportRepositoryTests: XCTestCase {

    var weatherRepo: WeatherReportRepository!

    public override func setUp() {
        let assembly = ApplicationAssembly()
        weatherRepo = assembly.coreComponents.weatherReportRepository()
    }

    public func test_save() {
        let currentConditions = CurrentConditions(summary: "Rain", temperature: Temperature(celsiusString: "24.5"),
                humidity: "81%", wind: "16KM E", imageUri: "")
        let forecast = [
            ForecastConditions(date: Date(), low: Temperature(celsiusString: "13"), high:Temperature(celsiusString: "24"))
        ]
        let report = PocketForecast(city: "Saxeburg", date: Date(), currentConditions: currentConditions, forecast: forecast)
        weatherRepo.saveReport(weatherReport: report)
    }

    public func test_load() {
        let currentConditions = CurrentConditions(summary: "Rain", temperature: Temperature(celsiusString: "24.5"),
                humidity: "81%", wind: "16KM E", imageUri: "")
        let forecast = [
            ForecastConditions(date: Date(), low: Temperature(celsiusString: "13"), high:Temperature(celsiusString: "24"))
        ]
        let report = PocketForecast(city: "Saxeburg", date: Date(), currentConditions: currentConditions, forecast: forecast)
        weatherRepo.saveReport(weatherReport: report)

        let loaded = weatherRepo.getReport(cityName: "Saxeburg")
        XCTAssertTrue(loaded != nil)
    }

}

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
import Promise

/**
 * A weather client backed by the world weather online (https://www.worldweatheronline.com/) service.
 */
class WeatherClientWorldWeatherImpl: WeatherClient {

    private(set) var reportRepo: WeatherReportRepository
    private(set) var serviceUrl: URL
    private(set) var daysToRetrieve: Int
    private(set) var apiKey: String

    init(reportRepo: WeatherReportRepository, serviceUrl: URL, daysToRetrieve: Int, apiKey: String) {
        self.reportRepo = reportRepo
        self.serviceUrl = serviceUrl
        self.daysToRetrieve = daysToRetrieve
        self.apiKey = apiKey
        assert(self.apiKey != "$$YOUR_API_KEY_HERE$$",
                "Please get an API key (v2) from: http://free.worldweatheronline.com, and then edit ProductionAppConfig or StagingAppConfig.")
    }

    func loadWeatherReportFor(city: String) -> Promise<PocketForecast> {
        Promise<PocketForecast>(work: { fulfill, reject in
            let url = self.queryURL(city: city)
            let data: Data! = try! Data(contentsOf: url)
            let report: WorldWeatherReport = try! JSONDecoder().decode(WorldWeatherReport.self, from: data)
            do {
                let pocketForecast = try report.toPocketForecast()
                self.reportRepo.saveReport(weatherReport: pocketForecast)
                fulfill(pocketForecast)
            }
            catch let error as PocketForecastError {
                reject(error)
            }
        })
    }

    private func queryURL(city: String) -> URL {
        var components = URLComponents(string: serviceUrl.absoluteString)!
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "num_of_days", value: String(describing: daysToRetrieve)),
            URLQueryItem(name: "key", value: apiKey)
        ]
        return components.url!
    }


}

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

class WeatherReportRepositoryFileSystemImpl: NSObject, WeatherReportRepository {

    func getReport(cityName: String) -> PocketForecast? {
        do {
            let data = try Data(contentsOf: pathFor(cityName: cityName))
            let report: PocketForecast = try! JSONDecoder().decode(PocketForecast.self, from: data)
            return report
        } catch let error {
            return nil
        }
    }

    func saveReport(weatherReport: PocketForecast) {
        do {
            let result = try JSONEncoder().encode(weatherReport)
            try result.write(to: pathFor(cityName: weatherReport.cityDisplayName))
        } catch let error {
            print("Failed to save report for: \(weatherReport.city). This is a non-fatal error")
        }
    }

    private func pathFor(cityName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("weatherReport$$\(cityName)")
    }
}

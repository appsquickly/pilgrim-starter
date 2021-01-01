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

class WeatherClientTests: XCTestCase {

    var weatherClient: WeatherClient!

    public override func setUp() {

        let assembly = ApplicationAssembly()
        weatherClient = assembly.coreComponents.weatherClient()
    }

    func test_it_receives_a_weather_report() {

        var receivedReport: PocketForecast?
        weatherClient.loadWeatherReportFor(city: "Manila")
            .then { weatherReport in
                receivedReport = weatherReport
            }
            .catch { error in
                XCTFail("Unexpected error: \(error)")
            }

        TestUtils.expect { () -> Bool in
            receivedReport != nil
        }
    }

    func test_it_invokes_error_block_given_invalid_city() {
        var recievedError: Error?
        weatherClient.loadWeatherReportFor(city: "Foobarville")
            .catch { error in
                recievedError = error
                print("Got message: \(error)")
            }

        TestUtils.expect(condition: { () -> Bool in
            recievedError != nil
        })
    }
}
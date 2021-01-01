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

/**
 * Translate a WorldWeather report response to the local PocketForecast model. Since the WorldWeatherReport is generated
 * code, we'll put the translation function in an extension.
 */
extension WorldWeatherReport {

    func toPocketForecast() throws -> PocketForecast {
        if data.error != nil {
            throw PocketForecastError(reasons: data.error!.map {
                $0.msg
            })
        }
        let city = data.request![0].query
        let date = Date()
        let currentConditions = data.currentCondition![0].toCurrentConditions()
        let forecast = data.weather!.map {
            $0.toForecastConditions()
        }
        return PocketForecast(city: city, date: date, currentConditions: currentConditions, forecast: forecast)
    }

}

extension CurrentCondition {

    func toCurrentConditions() -> CurrentConditions {
        let summary = weatherDesc[0].value
        let temperature = Temperature(fahrenheitString: tempF)
        let wind = "Wind: \(windspeedKmph!) km \(winddir16Point!)"
        let imageUri = weatherIconURL?[0].value ?? ""
        return CurrentConditions(summary: summary, temperature: temperature, humidity: humidity ?? "", wind: wind,
                imageUri: imageUri)
    }
}

extension WeatherElement {

    func toForecastConditions() -> ForecastConditions {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: self.date)!
        let low = Temperature(celsiusString: mintempC)
        let high = Temperature(celsiusString: maxtempC)
        return ForecastConditions(date: date, low: low, high: high)
    }

}


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

struct PocketForecast: Codable, CustomStringConvertible {
    
    private(set) var city : String
    private(set) var date : Date
    private(set) var currentConditions : CurrentConditions
    private(set) var forecast : Array<ForecastConditions>
    
    var cityDisplayName : String {
        let components : Array<String> = city.components(separatedBy: ",")
        if components.count > 1 {
            return components[0]
        }
        return city.capitalized
    }
    
    
    init(city : String, date : Date, currentConditions : CurrentConditions, forecast : [ForecastConditions]) {
        self.city = city
        self.date = date
        self.currentConditions = currentConditions
        self.forecast = forecast
    }

    func reportDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd',' yyyy 'at' hh:mm a"
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date)
    }
    
    var description: String {
        String("Weather Report: city=\(city), current conditions = \(currentConditions), forecast=\(forecast)")
    }
}

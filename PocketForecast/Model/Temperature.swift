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

enum TemperatureUnits : Int {
    case Celsius
    case Fahrenheit
}

struct Temperature : Codable, CustomStringConvertible {
    
    private var temperatureInFahrenheit: Decimal

    private var shortFormatter: NumberFormatter {
        let shortFormatter = NumberFormatter()
        shortFormatter.minimumFractionDigits = 0;
        shortFormatter.maximumFractionDigits = 0;
        return shortFormatter
    }

    private var longFormatter: NumberFormatter {
        let longFormatter = NumberFormatter()
        longFormatter.minimumFractionDigits = 0
        longFormatter.maximumFractionDigits = 1
        return longFormatter
    }

    static func defaultUnits() -> TemperatureUnits {
        TemperatureUnits(rawValue: UserDefaults.standard.integer(forKey: "pf.default.units"))!
    }

    static func setDefaultUnits(units : TemperatureUnits) {
        UserDefaults.standard.set(units.rawValue, forKey: "pf.default.units")
    }

    init(temperatureInFahrenheit : Decimal) {
        self.temperatureInFahrenheit = temperatureInFahrenheit;
    }
    
    init(fahrenheitString : String) {
        self.init(temperatureInFahrenheit:Decimal(string: fahrenheitString)!)
    }
    
    init(celsiusString: String) {
        let fahrenheit = (Decimal(string: celsiusString)! * 9.0 / 5.0) + 32.0
        self.init(temperatureInFahrenheit : fahrenheit)
    }

    func inFahrenheit() -> Decimal {
        temperatureInFahrenheit;
    }
    
    func inCelsius() -> Decimal {
        (temperatureInFahrenheit - 32.0) * 5.0 / 9.0
    }
    
    func asShortStringInDefaultUnits() -> String {
        if Temperature.defaultUnits() == TemperatureUnits.Celsius {
            return asShortStringInCelsius()
        }
        return asShortStringInFahrenheit()
    }
    
    func asLongStringInDefaultUnits() -> String {
        if Temperature.defaultUnits() == TemperatureUnits.Celsius {
            return asLongStringInCelsius()
        }
        return asLongStringInFahrenheit()
    }
    
    func asShortStringInFahrenheit() -> String {
         shortFormatter.string(for: inFahrenheit())! + "°"
    }

    func asLongStringInFahrenheit() -> String {
        longFormatter.string(for: inFahrenheit())! + "°"
    }
    
    func asShortStringInCelsius() -> String {
        shortFormatter.string(for: inCelsius())! + "°"
    }
    
    func asLongStringInCelsius() -> String {
        longFormatter.string(for: inCelsius())! + "°"
    }
    
    var description: String {
        "Temperature: \(asShortStringInFahrenheit())f [\(asShortStringInCelsius()) celsius]"
    }

}

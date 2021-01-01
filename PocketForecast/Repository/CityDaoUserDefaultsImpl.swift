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

class CityDaoUserDefaultsImpl : NSObject, CityRepository {
    
    var defaults : UserDefaults
    let citiesListKey = "pfWeather.cities"
    let currentCityKey = "pfWeather.currentCityKey"
    
    let defaultCities = [
        "Manila",
        "Madrid",
        "San Francisco",
        "Phnom Penh",
        "Omsk"
    ]
    
    
    init(defaults : UserDefaults) {
        self.defaults = defaults
    }
    
    func listAllCities() -> [String] {
        var cities : Array? = defaults.array(forKey: citiesListKey)
        if cities == nil {
            cities = defaultCities;
            defaults.set(cities, forKey:citiesListKey)
        }
        return (cities as! [String]).sorted {
            $0 < $1
        }
    }
    
    func saveCity(name: String) {
        let trimmedName = name.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let savedCities : Array? = defaults.array(forKey: citiesListKey)
        let cities: [String] = (savedCities != nil) ? savedCities as! [String] : defaultCities
        
        for city in cities {
            if city.lowercased() == trimmedName.lowercased() {
                return
            }
        }
        defaults.set(cities + [trimmedName], forKey: citiesListKey)
    }
    
    func deleteCity(name: String) {
        let trimmedName = name.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        var cities: [String] = defaults.array(forKey: citiesListKey) as! [String]
        
        for (index, city) in cities.enumerated() {
            if city.lowercased() == trimmedName.lowercased() {
                defaults.set(cities.remove(at: index), forKey: citiesListKey)
            }
        }
    }
    
    func saveCurrentlySelectedCity(cityName: String) {
        let trimmed = cityName.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !trimmed.isEmpty {
            defaults.set(trimmed, forKey: currentCityKey)
        }
    }

    func clearCurrentlySelectedCity() {
        defaults.set(nil, forKey: currentCityKey)
    }
    
    func loadSelectedCity() -> String? {
        defaults.string(forKey: currentCityKey)
    }
}

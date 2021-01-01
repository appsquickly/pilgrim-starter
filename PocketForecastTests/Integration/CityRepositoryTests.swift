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
import PilgrimDI
import XCTest
@testable import PocketForecast

class CityDaoTests : XCTestCase {
    
    var cityDao : CityRepository!
    
    override func setUp() {
        let assembly = ApplicationAssembly()
        cityDao = assembly.coreComponents.cityRepository()
    }
    
    func test_it_lists_all_cities_alphabetically() {
        let cities = cityDao.listAllCities()
        XCTAssertTrue(cities.count > 0)
    }
    
    func test_it_allows_adding_a_city() {
        cityDao.saveCity(name: "Manila")
        let cities = cityDao.listAllCities()
        
        XCTAssertTrue(cities.filter {$0 == "Manila"}.count == 1)
    }
    
    func test_adding_same_city_twice_does_not_create_duplicates() {
        cityDao.saveCity(name: "Manila")
        cityDao.saveCity(name: "Manila")
        
        let cities = cityDao.listAllCities()
        XCTAssertTrue(cities.filter {$0 == "Manila"}.count == 1)
    }

    func test_allows_removing_a_city() {
        cityDao.saveCity(name: "Wollongong")
        var cities = cityDao.listAllCities()
        XCTAssertTrue(cities.filter {$0 == "Wollongong"}.count == 1)
        cityDao.deleteCity(name: "Wollongong")
        cities = cityDao.listAllCities()
        XCTAssertTrue(cities.filter {$0 == "Wollongong"}.count == 0)
    }
}

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

/*
* City Repository (persistence) protocol.
* (Currently, injected protocols require the @objc annotation).
*/
protocol CityRepository {
    
    /**
    * Returns an array containing the names of all cities to report weather for.
    */
    func listAllCities() -> [String]
    
    /**
    * Adds a new city to the list of cities to report weather for. If the city already exists in 
    * the list, it is ignored.
    */
    func saveCity(name: String)
    
    /**
    * Removes the city with the specified name from the list of cities to report weather for. If 
    * the city doesn't exist in the list, it will be ignored.
    */
    func deleteCity(name: String)
    
    /**
    * Used to store the last page that the user visits.
    */
    func saveCurrentlySelectedCity(cityName: String)
    
    /**
    * Clears out the currently selected city.
    */
    func clearCurrentlySelectedCity()
    
    /**
    * Used to retrieve the last page that the user has visited, or nil if first use.
    */
    func loadSelectedCity() -> String?
    
}

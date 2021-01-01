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

struct CurrentConditions : Codable, CustomStringConvertible {
    
    private(set) var summary : String?
    private(set) var temperature : Temperature?
    private(set) var humidity : String?
    private(set) var wind : String?
    private(set) var imageUri : String?
    
    init(summary : String, temperature : Temperature, humidity : String, wind : String, imageUri : String) {
        self.summary = summary
        self.temperature = temperature
        self.humidity = humidity
        self.wind = wind
        self.imageUri = imageUri
    }
    
    func longSummary() -> String {
        "\(summary!). \(wind!)."
    }
    
    var description: String {
        String("Current Conditions: summary=\(summary), temperature=\(temperature)")
    }

}

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

class ThemeFactory {
    
    private var _sequentialTheme : Theme?
    private(set) var themes : Array<Theme>
    
    init(themes : Array<Theme>) {
        self.themes = themes
        assert(themes.count > 0, "ThemeFactory requires at least one theme in collection")
    }
    
    func sequentialTheme() -> Theme {
        if _sequentialTheme == nil {
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = NSString(string: paths[0])
            let indexFileName = documentsDirectory.appendingPathComponent("PF_CURRENT_THEME_INDEX")
            var index = (try? NSString(contentsOfFile: indexFileName, encoding: String.Encoding.utf8.rawValue))?.integerValue
            
            if index == nil || index! > themes.count - 1 {
                index = 0
            }
            _sequentialTheme = themes[index!]
            do {
                try NSString(format: "%i", (index! + 1)).write(toFile: indexFileName, atomically: false, encoding: String.Encoding.utf8.rawValue)
            } catch _ {
            }
        }
        return _sequentialTheme!
    }
}

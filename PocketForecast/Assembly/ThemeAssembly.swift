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
import NanoFrame

class ThemeAssembly: PilgrimAssembly {

    override func makeBindings() {
        super.makeBindings()
        makeInjectable(currentTheme, byType: Theme.self)
    }

    /**
     * Current-theme is emitted from the theme-factory, which increments the theme on each run of the application.
     */
    func currentTheme() -> Theme {
        shared(themeFactory().sequentialTheme())
    }

    /**
    * The theme factory contains a collection of each theme. Individual themes are using Typhoon's type-converter system to convert the
    * string representation of properties to their required runtime type.
    */
    func themeFactory() -> ThemeFactory {
        shared(ThemeFactory(themes: [
            cloudsOverTheCity(),
            stormySailing(),
            lightsInTheRain(),
            beach(),
            sunset()
        ]))
    }


    func cloudsOverTheCity() -> Theme {
        objectGraph {
            Theme(backgroundResourceName: "bg3.png", navigationBarColor: UIColor(hex: 0x641d23),
                    forecastTintColor: UIColor(hex: 0x641d23), controlTintColor: UIColor(hex: 0x7f9588))
        }
    }

    func stormySailing() -> Theme {
        objectGraph {
            Theme(backgroundResourceName: "stormySailing.jpg", navigationBarColor: UIColor(hex: 0xf8742c),
                    forecastTintColor: UIColor(hex: 0x4f7783), controlTintColor: UIColor(hex: 0x0c0b10))
        }
    }


    func lightsInTheRain() -> Theme {
        objectGraph {
            Theme(backgroundResourceName: "bg4.png", navigationBarColor: UIColor(hex: 0xeaa53d),
                    forecastTintColor: UIColor(hex: 0x722d49), controlTintColor: UIColor(hex: 0x722d49))
        }
    }


    func beach() -> Theme {
        objectGraph {
            Theme(backgroundResourceName: "bg5.png", navigationBarColor: UIColor(hex: 0x37b1da),
                    forecastTintColor: UIColor(hex: 0x37b1da), controlTintColor: UIColor(hex: 0x0043a6))
        }
    }

    func sunset() -> Theme {
        objectGraph {
            Theme(backgroundResourceName: "sunset.png", navigationBarColor: UIColor(hex: 0x0a1d3b),
                    forecastTintColor: UIColor(hex: 0x0a1d3b), controlTintColor: UIColor(hex: 0x606970))
        }
    }

}

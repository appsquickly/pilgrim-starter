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

import PilgrimDI

class CoreComponents: PilgrimAssembly {

    var config: AppConfig {
        #if STAGING
        return StagingAppConfig()
        #else
        return ProductionAppConfig()
        #endif
    }

    override func makeBindings() {
        super.makeBindings()
        makeInjectable(cityRepository, byType: CityRepository.self)
    }

    /**
     * Loads weather reports from the cloud service. ('scuse the pun).
     */
    func weatherClient() -> WeatherClient {
        objectGraph {
            WeatherClientWorldWeatherImpl(reportRepo: weatherReportRepository(), serviceUrl: config.serviceUrl,
                    daysToRetrieve:config.daysToRetrieve, apiKey: config.apiKey)
        }
    }

    /**
     * Responsible for loading and persisting weather reports from local storage.
     */
    func weatherReportRepository() -> WeatherReportRepository {
        objectGraph {
            WeatherReportRepositoryFileSystemImpl()
        }
    }

    /**
     * Responsible for loading and persisting cities.
     */
    func cityRepository() -> CityRepository {
        objectGraph {
            CityRepositoryUserDefaultsImpl(defaults: UserDefaults.standard)
        }
    }
}

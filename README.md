<a href="https://pilgrim.ph">![PilgrimSplash](https://pilgrim.ph/splash.jpg)</a>
# Pocket Forecast - UIKit Starter App

A UIKit example application built with <a href = "https://github.com/appsquickly/pilgrim">Pilgrim</a>. 

I'm looking into how Pilgrim/DI might fit into a pure SwiftUI application (if at all) and will provide a sample for that soon.  

### Features: 

* Returns weather reports from a remote cloud service
* Caches weather reports locally, for later off-line use. 
* Stores (creates, reads, updates deletes) the cities that the user is interested in receiving reports for. 
* Can use metric or imperial units. 
* Displays a different theme (background image, colors, etc) on each run. 

### Running the sample:

* Clone this repository, open the Xcode project in your favorite IDE, and run it. It'll say you need an API key.
* Get an API key from https://developer.worldweatheronline.com/ 
* Set the [ProductionAppConfig](https://github.com/appsquickly/pilgrim-starter/blob/main/PocketForecast/Assembly/config/ProductionAppConfig.swift) with your API key.  
* Run the App in the simulator or on your device. Look up the weather in your town, and put a jacket on, if you need 
to (Ha!).
  
### The App 
![Weather Report](https://github.com/appsquickly/pilgrim-starter/blob/main/Pilgrim%20Starter.gif)



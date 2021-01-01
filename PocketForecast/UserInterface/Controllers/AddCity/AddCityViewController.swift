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

import UIKit

class AddCityViewController: UIViewController, UITextFieldDelegate, Themeable {
    
    //Pilgrim injected properties
    
    var cityDao : CityRepository!
    var weatherClient : WeatherClient!
    var theme : Theme!
    var rootViewController : RootViewController!
    
    //Interface Builder injected properties
    
    @IBOutlet var nameOfCityToAdd: UITextField!
    @IBOutlet var validationMessage : UILabel!
    @IBOutlet var spinner : UIActivityIndicatorView!

    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required override init(nibName : String!, bundle : Bundle!)
    {
        super.init(nibName: nibName, bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
        
        nameOfCityToAdd.font = UIFont.applicationFontOfSize(size: 16)
        validationMessage.font = UIFont.applicationFontOfSize(size: 16)
        title = "Add City"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAdding))
        navigationItem.rightBarButtonItem = rightButton
        nameOfCityToAdd.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        validationMessage.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneAdding(textField: textField)
        return true
    }
        
    @objc private func doneAdding(textField : UITextField) {
        if !nameOfCityToAdd.text!.isEmpty {
            validationMessage.text = "Validating city . ."
            validationMessage.isHidden = false
            nameOfCityToAdd.isEnabled = false
            spinner.startAnimating()
            weatherClient.loadWeatherReportFor(city: self.nameOfCityToAdd.text!)
                .then { weatherReport in
                    self.cityDao!.saveCity(name: weatherReport.cityDisplayName)
                    self.rootViewController.dismissAddCitiesController()
                }
                .catch { error in
                    self.spinner.stopAnimating()
                    self.nameOfCityToAdd.isEnabled = true
                    self.validationMessage.text = String(format: "No weather reports for '%@'.", self.nameOfCityToAdd.text!)
                }
        }
        else {
            nameOfCityToAdd.resignFirstResponder()
            rootViewController.dismissAddCitiesController()
        }
    }
    
    private func applyTheme() {
        navigationController!.navigationBar.tintColor = .white
        navigationController!.navigationBar.barTintColor = theme.navigationBarColor
    }
        
}

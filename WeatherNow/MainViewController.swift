//
//  ViewController.swift
//  WeatherNow
//
//  Created by Lawrence Herb on 11/14/17.
//  Copyright © 2017 Larry Herb. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    private var blackOverlayView = UIView()
    private var locationContainerView = UIView()
    private var currentConditionsLabelArray = NSMutableArray()
    private var currentConditionsLabelContainerArray = NSMutableArray()
    private var locationNameLabel = UILabel()
    private var currentTemperatureLabel = UILabel()
    private var currentConditionsDescLabel = UILabel()
    private var weatherConditionIcon = UIImageView()
    private var currentWeatherObject :CurrentWeatherObject!
    private var openWeatherMapAPIKey = "API_KEY_HERE" //Register for an API Key Here: https://openweathermap.org/api/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        buildLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        //Begin by loading the location
        
        mainView.alpha = 0.0;
        loadLocation();
    }
    func displayLoadError(){
        //Display an Error
        DispatchQueue.main.async(execute: {
            //Load Next Screen
            
            let alert = UIAlertController(title: NSLocalizedString("mainView_loadCity_errorMessage_title", comment: "Error Title"), message:NSLocalizedString("mainView_loadCity_errorMessage", comment: "Load City Error Message"), preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: NSLocalizedString("mainView_loadCity_errorMessage_okButton", comment: "OK Button"), style: UIAlertAction.Style.default, handler: {(handler) in
                print("OK Button Pressed");
                self.performSegue(withIdentifier: "locationSettings_segue", sender: self);
            }));
            self.present(alert, animated: true, completion:nil);
        });
    }
    
    func loadLocation(){
        //Load the Location via URL Session Data Task
        
        let languageCode = String(format:"%@", Locale.current.languageCode!);
        
        locationNameLabel.text = UserDefaults.standard.string(forKey: "locationName");
        let urlString = String(format:"%@%@%@%@%@%@", "https://api.openweathermap.org/data/2.5/weather?q=", UserDefaults.standard.string(forKey: "locationName")!, "&appid=", openWeatherMapAPIKey, "&lang=", languageCode).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed);
        let url = URL(string: urlString!);
        if(url==nil){
            self.displayLoadError();
        }else{
            let request = URLRequest(url: url!);
            let config = URLSessionConfiguration.default;
            let session = URLSession(configuration: config);
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                //Perform Web Request Here
                if error != nil {
                    //Error Has Occured
                    self.displayLoadError();
                }else {
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        if let object = json as? [String: Any] {
                            // JSON is a dictionary valid object for this
                            self.currentWeatherObject = CurrentWeatherObject(dictionary: object);
                            self.addDataToInterface();
                            
                        } else if let object = json as? [Any] {
                            // JSON Format has changed to array
                            print ("Error: JSON Format has changed");
                            print(object);
                            self.displayLoadError();
                            
                        } else {
                            //Invalid JSON
                            print ("Error: Invalid JSON");
                            self.displayLoadError();
                        }
                    }catch{
                        //Error
                        print ("Error loading");
                        self.displayLoadError();
                    }
                }
            });
            task.resume()
        }
    }
    
    func convertKelvinToF(originalValue: Double)->Double{
        //Converts Kelvin Temperature to Fahrenheit
        
        var convertedValue = Double(0.0);
        convertedValue = originalValue*9/5-459.67;
        return convertedValue;
    }
    
    func addDataToInterface (){
        //Adds the Information to the UI Screen
        DispatchQueue.main.async(execute: {
            //Dispatch AJAX QUEUE
            if(self.currentWeatherObject.httpCode==200){
                //Everything is good url wise
                
                //Update Temperature
                let tempString = String(format: "%.0f", self.convertKelvinToF(originalValue: self.currentWeatherObject.weatherOverview.temperatureKelvin));
                self.currentTemperatureLabel.text = tempString+"°";
                
                //Add Conditions Description Strings
                var currentConditions = "";
                var conditionPosition=0;
                for condition in self.currentWeatherObject.weatherConditionsArray{
                    var startComma=", ";
                    if(conditionPosition==0){
                        //Add A Blank Start Comma and Load first Image Icon for Conditions
                        startComma="";
                        
                        //Create URL and Initate a HTTP Download Image Task
                        let iconURL = String(format:"%@%@%@", "https://openweathermap.org/img/w/", condition.iconCode, ".png");
                        let session = URLSession(configuration: .default)
                        self.weatherConditionIcon.alpha = 0.0;
                        let downloadImageTask = session.dataTask(with: URL(string: iconURL)!) { (data, response, error) in
                            //Load the Image into the Weather Condition Icon, and Print an Error if it occurs.
                            if let e = error {
                                //Display the actual error Message
                                print("Error Occurred: \(e)")
                            } else {
                                //Check if the Server actually responsed.
                                if (response as? HTTPURLResponse) != nil {
                                    //Validate that the data is an image
                                    if let imageData = data {
                                        //Get the Weather Icon Data and display on screen.
                                        let image = UIImage(data: imageData)
                                        DispatchQueue.main.async {
                                            self.weatherConditionIcon.image = image;
                                            self.weatherConditionIcon.alpha = 1.0;
                                        }
                                    } else {
                                        print("Image format is Invalid")
                                    }
                                } else {
                                    print("Server has not responded, Invalid URL.")
                                }
                            }
                        }
                        downloadImageTask.resume();
                    }
                    currentConditions = String(format:"%@%@%@", currentConditions, startComma, condition.conditionLabel);
                    conditionPosition = conditionPosition+1;
                }
                self.currentConditionsDescLabel.text = currentConditions;
                
                //Add Humidity String
                (self.currentConditionsLabelArray[0] as! UILabel).text = String(format: "%@ %@ %d%@", NSLocalizedString("mainView_currentConditions_humidityLabel", comment: "Humidity Label"), ": ", self.currentWeatherObject.weatherOverview.humidity, "%");
                
                //Add Wind Info
                let degreesString = String(format:"%.1f", self.currentWeatherObject.wind.degrees);
                (self.currentConditionsLabelArray[1] as! UILabel).text=String(format: "%@ %@ %.1f %@ %@ %@%@", NSLocalizedString("mainView_currentConditions_windLabel", comment: "Wind Label"), ": ", self.currentWeatherObject.wind.speed, NSLocalizedString("mainView_CurrentConditions_metersPerSecondLabel", comment: "Meters Per Second Label"), "@", degreesString, "°");
                
                //Add Pressure Info
                (self.currentConditionsLabelArray[2] as! UILabel).text = String(format:"%@ %@ %d %@", NSLocalizedString("mainView_currentConditions_pressureLabel", comment: "Pressure Label"), ": ", self.currentWeatherObject.weatherOverview.pressure, "mb");
                
                //Add Min Temperature Info
                (self.currentConditionsLabelArray[3] as! UILabel).text = String(format:"%@ %@ %0.0f%@", NSLocalizedString("mainView_currentConditions_minLabel", comment: "Pressure Label"), ": ", self.convertKelvinToF(originalValue:self.currentWeatherObject.weatherOverview.temperatureKelvinMin), "°");
                
                //Add Max Temperature Info
                (self.currentConditionsLabelArray[4] as! UILabel).text = String(format:"%@ %@ %0.0f%@", NSLocalizedString("mainView_currentConditions_maxLabel", comment: "Pressure Label"), ": ", self.convertKelvinToF(originalValue:self.currentWeatherObject.weatherOverview.temperatureKelvinMax), "°");
                
                //Update Temperature
                self.animateInterfaceIn();
            }else{
                self.displayLoadError();
            }
        });
    }
    
    func animateInterfaceIn(){
        //Visual Effect for Loading the Interface In
        
        DispatchQueue.main.async(execute: {
            //Async Method
            self.currentTemperatureLabel.alpha = 0.0;
            self.currentTemperatureLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
            self.mainView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25);
            self.mainView.alpha = 0.0;
            self.weatherConditionIcon.alpha = 0.0;
            
            for i in (0..<5){
                (self.currentConditionsLabelContainerArray[i] as! UIView).alpha=0.0;
            }
            UIView.animate(withDuration: 0.25, delay: 0, options:[.curveEaseIn], animations: {
                self.mainView.alpha = 1.0;
                self.mainView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            }) { _ in
                //Done Animating
                UIView.animate(withDuration: 0.25, delay: 0, options:[.curveEaseOut], animations: {
                    self.currentTemperatureLabel.alpha = 1.0;
                    self.currentTemperatureLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                }) { _ in
                    //Done Animating
                    for i in (0..<5){
                        
                        UIView.animate(withDuration: 0.25, delay: Double(i)*0.25, options:[.curveEaseOut], animations: {
                            (self.currentConditionsLabelContainerArray[i] as! UIView).alpha=1.0;
                        }) { _ in
                            //Done Animating
                        }
                    }
                }
            }
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildLayout(){
        //The Layout is built here
        
        self.view.backgroundColor = UIColor.init(red: 0.16, green: 0.42, blue: 0.67, alpha: 1.0);
        mainView.backgroundColor = UIColor.init(red: 0.16, green: 0.42, blue: 0.67, alpha: 1.0);
        
        //--- [Phone Status Bar] ---
        let phoneStatusBarBG = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: UIApplication.shared.statusBarFrame.size.height))
        phoneStatusBarBG.backgroundColor = UIColor.black;
        phoneStatusBarBG.alpha = 0.25;
        self.view.addSubview(phoneStatusBarBG);
        
        //===================================
        //= TOP HALF
        //===================================
        
        //High Level Information Container
        let topHalfView = UIView(frame: CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height, width: mainView.frame.size.width-30, height: ((mainView.frame.size.height-UIApplication.shared.statusBarFrame.height)/2) ))
        mainView.addSubview(topHalfView);
        
        //-----------------------------------
        //- Location Selector
        //-----------------------------------
        locationContainerView = UIView(frame: CGRect(x: 0, y: 15, width: topHalfView.frame.size.width, height: 60));
        topHalfView.addSubview(locationContainerView);
        
        let locationIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 60));
        let locationIconImage = UIImage(named: "location_icon.png");
        locationIconImageView.image = locationIconImage;
        locationIconImageView.contentMode = UIView.ContentMode.scaleAspectFit;
        locationContainerView.addSubview(locationIconImageView);
        
        let locationSelectorWhiteBorderView = UIView(frame: CGRect(x: 0, y: locationContainerView.frame.size.height-4, width: locationContainerView.frame.size.width, height: 4))
        locationSelectorWhiteBorderView.backgroundColor = UIColor.white;
        locationContainerView.addSubview(locationSelectorWhiteBorderView);
        
        locationNameLabel = UILabel(frame: CGRect(x: 50, y: (locationContainerView.frame.size.height-20)/2, width: locationContainerView.frame.size.width, height: 20))
        locationNameLabel.text =  "Loading...";
        locationNameLabel.textColor = UIColor.white;
        locationNameLabel.font = locationNameLabel.font.withSize(20);
        locationNameLabel.textAlignment = NSTextAlignment.left;
        locationContainerView.addSubview(locationNameLabel);
        
        let buttonOverlay = UIButton(frame: CGRect(x: 0, y: 0, width: locationContainerView.frame.size.width, height: locationContainerView.frame.size.height));
        buttonOverlay.addTarget(self, action: #selector(locationbtnAction(sender:)), for: .touchUpInside);
        locationContainerView.addSubview(buttonOverlay);
        
        //-----------------------------------
        //- Temperature Code
        //-----------------------------------
        
        //Temperature Container
        let temperatureContainer = UIView(frame: CGRect(x: 0, y: locationContainerView.frame.origin.y+locationContainerView.frame.size.height, width: locationContainerView.frame.size.width, height: (topHalfView.frame.size.height-locationContainerView.frame.size.height)-30 ))
        topHalfView.addSubview(temperatureContainer)
        
        //Current Temp Text
        currentTemperatureLabel = UILabel(frame: CGRect(x: 0, y: 15, width: temperatureContainer.frame.size.width, height: (temperatureContainer.frame.size.height/3)*2 ));
        currentTemperatureLabel.text = "-°";
        currentTemperatureLabel.textColor = UIColor.white;
        currentTemperatureLabel.textAlignment = NSTextAlignment.center;
        currentTemperatureLabel.font = currentTemperatureLabel.font.withSize(80);
        temperatureContainer.addSubview(currentTemperatureLabel);
        
        let currentConditionsSummaryView = UIView(frame: CGRect(x: 0, y: currentTemperatureLabel.frame.origin.y+currentTemperatureLabel.frame.size.height, width: temperatureContainer.frame.size.width, height: (temperatureContainer.frame.size.height/3)*1 ));
        temperatureContainer.addSubview(currentConditionsSummaryView);
        
        //Weather Condition Icon
        weatherConditionIcon = UIImageView(frame: CGRect(x: (currentConditionsSummaryView.frame.size.width-40)/2, y: 0, width: 40, height: currentConditionsSummaryView.frame.size.height/2));
        let weatherConditionIconImage = UIImage(named: "location_icon.png");
        //http://openweathermap.org/img/w/10n.png
        weatherConditionIcon.image = weatherConditionIconImage;
        weatherConditionIcon.contentMode = UIView.ContentMode.scaleAspectFit;
        currentConditionsSummaryView.addSubview(weatherConditionIcon);
        
        //Current Conditions Desc Text
        currentConditionsDescLabel = UILabel(frame: CGRect(x: 0, y: currentConditionsSummaryView.frame.size.height/2, width: temperatureContainer.frame.size.width, height: currentConditionsSummaryView.frame.size.height/2));
        currentConditionsDescLabel.text = "Loading...";
        currentConditionsDescLabel.textColor = UIColor.white;
        currentConditionsDescLabel.textAlignment = NSTextAlignment.center;
        currentConditionsDescLabel.font = currentConditionsDescLabel.font.withSize(20);
        currentConditionsSummaryView.addSubview(currentConditionsDescLabel);
        
        //===================================
        //= BOTTOM HALF
        //===================================
        let bottomHalfView = UIView(frame: CGRect(x: 15, y: topHalfView.frame.origin.y+topHalfView.frame.size.height, width: mainView.frame.size.width-30, height: ((mainView.frame.size.height-UIApplication.shared.statusBarFrame.height)/2)-15 ));
        mainView.addSubview(bottomHalfView);
        
        let currentConditionsHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: bottomHalfView.frame.size.width, height: 60 ))
        bottomHalfView.addSubview(currentConditionsHeaderContainerView)
        
        let whiteBorderCurrentConditionsView = UIView(frame: CGRect(x: 0, y: currentConditionsHeaderContainerView.frame.size.height-4, width: currentConditionsHeaderContainerView.frame.size.width, height: 2))
        whiteBorderCurrentConditionsView.backgroundColor = UIColor.white;
        currentConditionsHeaderContainerView.addSubview(whiteBorderCurrentConditionsView);
        
        let currentConditionsLabel = UILabel(frame: CGRect(x: 0, y: (locationContainerView.frame.size.height-20)/2, width: locationContainerView.frame.size.width, height: 20))
        currentConditionsLabel.text = NSLocalizedString("mainView_currentConditions_titleLabel", comment: "Current Condition Header Label");
        currentConditionsLabel.textColor = UIColor.white;
        currentConditionsLabel.font = locationNameLabel.font.withSize(20);
        currentConditionsLabel.textAlignment = NSTextAlignment.left;
        currentConditionsHeaderContainerView.addSubview(currentConditionsLabel);
        
        let conditionsContainer = UIView(frame: CGRect(x: 0, y: currentConditionsHeaderContainerView.frame.origin.y+currentConditionsHeaderContainerView.frame.size.height, width: bottomHalfView.frame.size.width, height: ((mainView.frame.size.height-UIApplication.shared.statusBarFrame.height)/2)-15 ));
        bottomHalfView.addSubview(conditionsContainer);
        
        for i in (0..<5){
            //Create 5 items
            let conditionsItemView = generateCurrentConditionsInformation(postion:i, parentView: conditionsContainer);
            conditionsContainer.addSubview(conditionsItemView)
        }
    }
    
    @objc func locationbtnAction(sender:UIButton){
        //The Button Has Been Selected
        UIView.animate(withDuration: 0.15, delay: 0, options:[.curveEaseIn], animations: {
            self.locationContainerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.90)
        }) { _ in
            //Segue
            UIView.animate(withDuration: 0.15, delay: 0, options:[.curveEaseIn], animations: {
                self.locationContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { _ in
                //Segue
                UIView.animate(withDuration: 0.25, delay: 0, options:[.curveEaseIn], animations: {
                    self.mainView.alpha = 0.0;
                    self.view.backgroundColor = UIColor.black;
                }) { _ in
                    self.performSegue(withIdentifier: "locationSettings_segue", sender: self);
                    UIView.animate(withDuration: 0.25, delay: 0, options:[.curveEaseIn], animations: {
                        self.mainView.alpha = 1.0;
                        self.view.backgroundColor = UIColor.init(red: 0.16, green: 0.42, blue: 0.67, alpha: 1.0);
                    }) { _ in
                        //Complete Action
                    }
                }
            }
        }
    }
    
    func generateCurrentConditionsInformation(postion:Int, parentView:UIView)->UIView{
        //Generate A Current Conditions Information View
        let generatedConditionsItemView = UIView(frame: CGRect(x: 0, y: Int(postion)*40, width: Int(parentView.frame.size.width), height: 40))
        
        let whiteBorderView = UIView(frame: CGRect(x: 0, y: generatedConditionsItemView.frame.size.height-4, width: generatedConditionsItemView.frame.size.width, height: 1))
        whiteBorderView.backgroundColor = UIColor.white;
        whiteBorderView.alpha = 0.25;
        generatedConditionsItemView.addSubview(whiteBorderView);
        
        let currentConditionsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: generatedConditionsItemView.frame.size.width, height: generatedConditionsItemView.frame.size.height-5))
        currentConditionsLabel.text = "Loading...";
        currentConditionsLabel.textColor = UIColor.white;
        currentConditionsLabel.font = locationNameLabel.font.withSize(12);
        currentConditionsLabel.textAlignment = NSTextAlignment.left;
        generatedConditionsItemView.addSubview(currentConditionsLabel);
        currentConditionsLabelArray.add(currentConditionsLabel);
        currentConditionsLabelContainerArray.add(generatedConditionsItemView);
        
        return generatedConditionsItemView;
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        //Use the Light Stylebar
        return UIStatusBarStyle.lightContent;
    }
}

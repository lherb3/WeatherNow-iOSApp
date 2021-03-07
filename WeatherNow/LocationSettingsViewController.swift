//
//  LocationSettingsViewController.swift
//  WeatherNow
//
//  Created by Lawrence Herb on 11/15/17.
//  Copyright © 2017 Larry Herb. All rights reserved.
//

import UIKit

class LocationSettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    private var locationTextboxContainerView = UIView()
    private var indicatorCurrentLocationLabel = UILabel()
    private var indicatorTopLabel = UILabel()
    private var searchTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buildLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        //View is about to appear
        animateInterfaceIn();
    }
    
    func validateTextEntry(){
        //Validate Text Entry
        searchTextField.resignFirstResponder();
        if(searchTextField.text!==""){
            //Empty Textbox
            let alert = UIAlertController(title: NSLocalizedString("locationSettingsView_popupMessage_enterCityTitle", comment: "Please Enter A City Title"), message:NSLocalizedString("locationSettingsView_popupMessage_enterCity", comment: "Enter City Name"), preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: NSLocalizedString("locationSettingsView_popupMessage_okBtn", comment: "OK Button"), style: UIAlertAction.Style.default, handler: nil));
            self.present(alert, animated: true, completion: nil)
        }else{
            //Text Box Has Text
            UserDefaults.standard.set(searchTextField.text, forKey: "locationName");
            UserDefaults.standard.synchronize();
            closeScreen();
        }
    }
    
    func closeScreen() {
        UIView.animate(withDuration: 0.25, delay: 0, options:[.curveEaseOut], animations: {
            self.mainView.alpha = 0.0;
        }) { _ in
            //Done Animating
            self.dismiss(animated: true, completion: nil);
        }
    }
    
    func animateInterfaceIn(){
        //Visual Effect for Loading the Interface In
        indicatorTopLabel.alpha = 0.0;
        indicatorCurrentLocationLabel.alpha = 0.0;
        indicatorCurrentLocationLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25);
        locationTextboxContainerView.alpha = 0.0;
        mainView.alpha = 1.0;
        UIView.animate(withDuration: 0.25, delay: 0, options:[.curveEaseOut], animations: {
            self.indicatorTopLabel.alpha = 1.0;
        }) { _ in
            UIView.animate(withDuration: 0.75, delay: 0, options:[.curveEaseOut], animations: {
                self.indicatorCurrentLocationLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                self.indicatorCurrentLocationLabel.alpha = 1.0;
            }) { _ in
                UIView.animate(withDuration: 0.25, delay: 0, options:[.curveEaseOut], animations: {
                    self.locationTextboxContainerView.alpha = 1.0;
                }) { _ in
                    //Done Animating
                }
            }
        }
    }
    
    func buildLayout(){
        //The Layout is built here
        
        self.view.backgroundColor = UIColor.black;
        mainView.backgroundColor = UIColor.black;
        mainView.alpha = 0.0;
        
        //--- [Phone Status Bar] ---
        let phoneStatusBarBG = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: UIApplication.shared.statusBarFrame.size.height))
        phoneStatusBarBG.backgroundColor = UIColor.black;
        phoneStatusBarBG.alpha = 0.25;
        self.view.addSubview(phoneStatusBarBG);
        
        //===================================
        //= TOP HALF
        //===================================
        
        //High Level Information Container
        let topHalfView = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: mainView.frame.size.width, height: ((mainView.frame.size.height-UIApplication.shared.statusBarFrame.height)/2) ))
        mainView.addSubview(topHalfView)
        
        let backButton = UIButton(frame: CGRect(x: 15, y: 0, width: 100, height: 60));
        backButton.setTitle(NSLocalizedString("locationSettingsView_backBtn", comment: "Back Button Text"), for: UIControl.State.normal);
        backButton.titleLabel?.font =  backButton.titleLabel?.font.withSize(20);
        backButton.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside);
        backButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        backButton.setTitleColor(UIColor.white, for: UIControl.State.normal);
        topHalfView.addSubview(backButton);
        
        //-----------------------------------
        //- Location Textbox Container
        //-----------------------------------
        //Location Container
        locationTextboxContainerView = UIView(frame: CGRect(x:15, y:topHalfView.frame.size.height-60, width:topHalfView.frame.size.width-30, height:60));
        topHalfView.addSubview(locationTextboxContainerView);
        
        searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: locationTextboxContainerView.frame.size.width, height: locationTextboxContainerView.frame.size.height-4));
        searchTextField.font =  searchTextField.font?.withSize(20);
        searchTextField.textColor = UIColor.white;
        searchTextField.background = nil;
        searchTextField.delegate = self;
        searchTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        let placeholder = NSAttributedString(string: NSLocalizedString("locationSettingsView_enterCity", comment: "Enter City Name Here Text"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        searchTextField.attributedPlaceholder = placeholder;
        locationTextboxContainerView.addSubview(searchTextField);
        
        //Add Gesture Recognizer to remove keyboard
        let elsewhereTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
        view.addGestureRecognizer(elsewhereTap)
        
        let locationSelectorWhiteBorderView = UIView(frame: CGRect(x: 0, y: locationTextboxContainerView.frame.size.height-4, width: locationTextboxContainerView.frame.size.width, height: 4))
        locationSelectorWhiteBorderView.backgroundColor = UIColor.white;
        locationTextboxContainerView.addSubview(locationSelectorWhiteBorderView);
        
        let applyButton = UIButton(frame: CGRect(x: locationTextboxContainerView.frame.size.width-40, y: 0, width: 40, height: 60-4));
        let locationIconImage = UIImage(named: "search_icon.png");
        applyButton.setImage(locationIconImage, for: UIControl.State.normal);
        applyButton.contentMode = UIView.ContentMode.scaleAspectFit;
        applyButton.addTarget(self, action: #selector(applyBtnAction), for: .touchUpInside);
        locationTextboxContainerView.addSubview(applyButton);
        
        //-----------------------------------
        //- Set To Indicator Code
        //-----------------------------------
        let setToIndicatorContainerView = UIView(frame:CGRect(x: 0, y: 50, width: topHalfView.frame.size.width, height: (topHalfView.frame.size.height-60)-50));
        topHalfView.addSubview(setToIndicatorContainerView);
        
        //Center It
        let indicatorTextContainerView = UIView(frame:CGRect(x: 0, y: (setToIndicatorContainerView.frame.size.height-80)/2, width: setToIndicatorContainerView.frame.size.width, height: 70));
        setToIndicatorContainerView.addSubview(indicatorTextContainerView);
        
        //Top Indicator Label
        indicatorTopLabel = UILabel(frame: CGRect(x: 0, y: 0, width: indicatorTextContainerView.frame.size.width, height: 20))
        indicatorTopLabel.text = NSLocalizedString("locationSettingsView_currentlySetToLabel", comment: "Currently Set to Label");
        indicatorTopLabel.textColor = UIColor.white;
        indicatorTopLabel.font = indicatorTopLabel.font.withSize(16);
        indicatorTopLabel.textAlignment = NSTextAlignment.center;
        indicatorTextContainerView.addSubview(indicatorTopLabel);
        
        //Bottom Indicator Label
        indicatorCurrentLocationLabel = UILabel(frame: CGRect(x: 0, y: indicatorTopLabel.frame.origin.y+indicatorTopLabel.frame.size.height+10, width: indicatorTextContainerView.frame.size.width, height: 40))
        indicatorCurrentLocationLabel.text = UserDefaults.standard.string(forKey: "locationName");
        indicatorCurrentLocationLabel.textColor = UIColor.white;
        indicatorCurrentLocationLabel.font = indicatorCurrentLocationLabel.font.withSize(36);
        indicatorCurrentLocationLabel.textAlignment = NSTextAlignment.center;
        indicatorTextContainerView.addSubview(indicatorCurrentLocationLabel);
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        //Text Field Should End Editing
        textField.resignFirstResponder();
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        //Text Field Should Return Delegate Industry
        searchTextField.resignFirstResponder()
        view.endEditing(true);
        validateTextEntry();
        return true
    }
    
    @objc func removeKeyboard() {
        //Removes the keyboard from view.
        view.endEditing(true)
    }
    
    @objc func backBtnAction(sender:UIButton){
        //The Back Button was selected
        closeScreen();
        
    }
    
    @objc func applyBtnAction(sender:UIButton){
        //The Apply Button was selected
        
        view.endEditing(true);
        searchTextField.resignFirstResponder()
        validateTextEntry();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        //Use the Light Stylebar
        return UIStatusBarStyle.lightContent;
    }
}

//
//  IntroViewController.swift
//  WeatherNow
//
//  Created by Lawrence Herb on 11/14/17.
//  Copyright © 2017 Larry Herb. All rights reserved.
//

import UIKit
import QuartzCore

class IntroViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    private var brandBoxStartPosition = CGRect()
    private var brandBoxFinalPosition = CGRect()
    
    private var copyrightStartPosition = CGRect()
    private var copyrightFinalPosition = CGRect()
    
    private var brandBoxView:UIView = UIView()
    private var weatherNowTitleLabel = UILabel()
    private var copyrightContainerView = UIView()
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        buildLayout()
        
        if UserDefaults.standard.bool(forKey: "returningUser")==false{
            UserDefaults.standard.set(true, forKey: "returningUser");
            UserDefaults.standard.set("New York", forKey: "locationName");
            UserDefaults.standard.synchronize();
        }
        
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
        //Brand Layout
        brandBoxFinalPosition = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: mainView.frame.size.width, height: (mainView.frame.size.height-UIApplication.shared.statusBarFrame.height)/2 );
        brandBoxStartPosition = CGRect(x: brandBoxFinalPosition.size.width, y: brandBoxFinalPosition.origin.y, width: brandBoxFinalPosition.size.width, height: brandBoxFinalPosition.size.height);
        brandBoxView = UIView(frame: brandBoxStartPosition);
        mainView.addSubview(brandBoxView);
        
        //Weather Now Logo
        let weatherNowLogoImageView = UIImageView(frame: CGRect(x: (brandBoxView.frame.size.width-200)/2, y: (brandBoxView.frame.size.height-245), width: 200, height: 175));
        let weatherImage = UIImage(named: "weather_launch_image.png");
        weatherNowLogoImageView.image = weatherImage;
        weatherNowLogoImageView.contentMode = UIView.ContentMode.scaleAspectFit;
        brandBoxView.addSubview(weatherNowLogoImageView);
        
        //Weather Now Text
        weatherNowTitleLabel = UILabel(frame: CGRect(x: 30, y: weatherNowLogoImageView.frame.size.height+weatherNowLogoImageView.frame.origin.y+30, width: brandBoxView.frame.size.width-60, height: 40));
        weatherNowTitleLabel.text = NSLocalizedString("introView_appTitle", comment: "The Title of the App");
        weatherNowTitleLabel.textColor = UIColor.white;
        weatherNowTitleLabel.alpha = 0.0;
        weatherNowTitleLabel.font = weatherNowTitleLabel.font.withSize(36);
        weatherNowTitleLabel.textAlignment = NSTextAlignment.center;
        brandBoxView.addSubview(weatherNowTitleLabel);
        
        //===================================
        //= BOTTOM HALF
        //===================================
        //Copyright Container
        copyrightFinalPosition = CGRect(x: 30, y: mainView.frame.size.height-60, width: mainView.frame.size.width-60, height: 60);
        copyrightStartPosition = CGRect(x: copyrightFinalPosition.origin.x, y: mainView.frame.size.height, width: copyrightFinalPosition.size.width, height: copyrightFinalPosition.size.height);
        copyrightContainerView = UIView(frame: copyrightStartPosition);
        mainView.addSubview(copyrightContainerView);
        
        //Copyright Container White
        let whiteBorderView = UIView(frame: CGRect(x: 0, y: 0, width: copyrightContainerView.frame.size.width, height: 1))
        whiteBorderView.alpha = 0.25;
        whiteBorderView.backgroundColor = UIColor.white;
        copyrightContainerView.addSubview(whiteBorderView)
        
        //Copyright Text View
        let copyrightLabel = UILabel(frame: CGRect(x: 0, y: 1, width: copyrightContainerView.frame.size.width, height: copyrightContainerView.frame.size.height-1));
        copyrightLabel.text = NSLocalizedString("introView_copyrightText", comment: "A Copyright Notice for the App");
        copyrightLabel.textColor = UIColor.white;
        copyrightLabel.font = weatherNowTitleLabel.font.withSize(16);
        copyrightLabel.textAlignment = NSTextAlignment.center;
        copyrightContainerView.addSubview(copyrightLabel);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Animate Brand Box
        UIView.animate(withDuration: 0.75, delay: 0, options:[.curveEaseIn], animations: {
            self.brandBoxView.frame = self.brandBoxFinalPosition;
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options:[.curveEaseIn], animations: {
                self.weatherNowTitleLabel.alpha = 1.0;
            }) { _ in
                UIView.animate(withDuration: 0.75, delay: 0, options:[.curveEaseIn], animations: {
                    self.copyrightContainerView.frame = self.copyrightFinalPosition;
                }) { _ in
                    UIView.animate(withDuration: 0.75, delay: 0, options:[.curveEaseIn], animations: {
                        self.mainView.alpha = 0.0;
                    }) { _ in
                        //Segue
                        self.performSegue(withIdentifier: "mainmenu_segue", sender: self);
                    }
                }
            }
        }
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

//
//  SecondViewController.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/24/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON

class SecondViewController: UIViewController {


    @IBOutlet weak var windSpeedData: UILabel!
    @IBOutlet weak var pressureData: UILabel!
    @IBOutlet weak var precipitationData: UILabel!
    @IBOutlet weak var temperatureData: UILabel!
    @IBOutlet weak var nightWeatherData: UILabel!
    @IBOutlet weak var humidityData: UILabel!
    @IBOutlet weak var visibilityData: UILabel!
    @IBOutlet weak var cloudCoverData: UILabel!
    @IBOutlet weak var ozoneData: UILabel!
    @IBOutlet weak var weeklySum: UIImageView!
    
    var city: String = ""
    var state: String = ""
    var currently: JSON = [:]
    var daily: JSON = [:]
    var weatherTemp: String = ""
    var weatherCondition: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = self.city
        let twitterImg: UIImage = UIImage(named: "twitter.png")!
        let tweetButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        tweetButton.tintColor = UIColor.blue
        tweetButton.setImage(twitterImg, for: .normal)
        tweetButton.addTarget(self, action: #selector(SecondViewController.createTweet), for: .touchUpInside)
        let twitterButton = UIBarButtonItem(customView: tweetButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = twitterButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.todayNavBar.rightBarButtonItem = twitterButton
        // Do any additional setup after loading the view.
        SwiftSpinner.show("Fetching Weather Details for " + city)
//        let networkClient = NetworkClient()
//        let cityWeatherUrl = "https://weatherservice571.azurewebsites.net/street/*/city/" + self.city + "/state/" + self.state
//
//        guard let getUrl = URL(string: cityWeatherUrl) else {
//            return
//        }
//        networkClient.fetch(getUrl) { (json, error) in
//            if let error = error {
//                debugPrint(error)
//                SwiftSpinner.hide()
//            }
//            else {
//                let jsonUnwrapped = JSON(json)
//                if(jsonUnwrapped["status"].stringValue == "OK") {
//                    self.currently = jsonUnwrapped["currently"]
//                    self.daily = jsonUnwrapped["daily"]
//                    let barViewControllers = self.tabBarController as! UITabBarController
//                    let destinationViewController = barViewControllers.viewControllers![1] as! FirstViewController
//                    destinationViewController.daily = self.daily
//                    destinationViewController.city = self.city
//                    debugPrint(self.currently)
//                    SwiftSpinner.hide()
//                }
//                else {
//                    debugPrint("Error returning api")
//                    SwiftSpinner.hide()
//                }
//            }
//        }

        if let summary = self.currently["summary"].string {
            self.nightWeatherData.text = summary
        }
        
        if let currentTemp = self.currently["temperature"].double {
            self.temperatureData.text = String(Int(currentTemp.rounded())) + " ˚F"
        }
        
        if let currentHumidity = self.currently["humidity"].double {
            self.humidityData.text = String((currentHumidity * 100.0).rounded()) + " %"
        }
        
        if let currentWind = self.currently["windSpeed"].double {
            self.windSpeedData.text = String(format: "%.2f", currentWind) + " mph"
        }
        
        if let currentVis = self.currently["visibility"].double {
            self.visibilityData.text = String(format: "%.2f", currentVis) + " km"
        }
        
        if let currentPres = self.currently["pressure"].double {
            self.pressureData.text = String(format: "%.1f", currentPres) + " mb"
        }
        
        if let ozone = self.currently["ozone"].double {
            self.ozoneData.text = String(format: "%.1f", ozone) + " DU"
        }
        
        if let cloudCover = self.currently["cloudCover"].double {
            self.cloudCoverData.text = String(format: "%.2f", cloudCover * 100.0) + " %"
        }
        
        if let precip = self.currently["precipIntensity"].double {
            self.precipitationData.text = String(format: "%.1f", precip * 100.0) + " %"
        }
        
        let icon = self.currently["icon"].string!.lowercased()
        if(icon == "partly-cloudy-night") {
            let img = UIImage(named: "weather-night-partly-cloudy")
            self.weeklySum.image = img
        }
        else if (icon == "clear-day") {
            let img = UIImage(named: "weather-sunny")
            self.weeklySum.image = img
        }
        else if (icon == "rain") {
            let img = UIImage(named: "weather-rainy")
            self.weeklySum.image = img
        }
        else if (icon == "snow") {
            let img = UIImage(named: "weather-snowy")
            self.weeklySum.image = img
        }
        else if (icon == "sleet") {
            let img = UIImage(named: "weather-snowy-rainy")
            self.weeklySum.image = img
        }
        else if (icon == "wind") {
            let img = UIImage(named: "weather-windy")
            self.weeklySum.image = img
        }
        else if (icon == "fog") {
            let img = UIImage(named: "weather-fog")
            self.weeklySum.image = img
        }
        else if (icon == "cloudy") {
            let img = UIImage(named: "weather-cloudy")
            self.weeklySum.image = img
        }
        else if (icon == "partly-cloudy-day") {
            let img = UIImage(named: "weather-partly-cloudy")
            self.weeklySum.image = img
        }
        
        debugPrint(self.currently)
        
        SwiftSpinner.hide()
    }
    
    @objc func createTweet() {
        debugPrint("it works")
        let twitterUrl = "https://twitter.com/intent/tweet?text=The current temperature at " + self.city + " is " + self.weatherTemp + ". The weather conditions are " + self.weatherCondition + "&hashtags=CSCI571WeatherSearch"
        let encodedTwitterUrl = twitterUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let twitterLink = URL(string: encodedTwitterUrl!)
        debugPrint(twitterLink)
        if UIApplication.shared.canOpenURL(twitterLink!) {
            debugPrint(twitterLink)
            UIApplication.shared.open(twitterLink!, options: [:], completionHandler: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

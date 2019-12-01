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


    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var precipitation: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var nightWeather: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var ozone: UILabel!
    
    var city: String = ""
    var state: String = ""
    var currently: JSON = [:]
    var daily: JSON = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = self.city
        let twitterImg: UIImage = UIImage(named: "twitter.png")!
        let tweetButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
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
        let networkClient = NetworkClient()
        let cityWeatherUrl = "https://weatherservice571.azurewebsites.net/street/*/city/" + self.city + "/state/" + self.state
        
        guard let getUrl = URL(string: cityWeatherUrl) else {
            return
        }
        networkClient.fetch(getUrl) { (json, error) in
            if let error = error {
                debugPrint(error)
                SwiftSpinner.hide()
            }
            else {
                let jsonUnwrapped = JSON(json)
                if(jsonUnwrapped["status"].stringValue == "OK") {
                    self.currently = jsonUnwrapped["currently"]
                    self.daily = jsonUnwrapped["daily"]
                    let barViewControllers = self.tabBarController as! UITabBarController
                    let destinationViewController = barViewControllers.viewControllers![1] as! FirstViewController
                    destinationViewController.daily = self.daily
                    destinationViewController.city = self.city
                    debugPrint(self.currently)
                    SwiftSpinner.hide()
                }
                else {
                    debugPrint("Error returning api")
                    SwiftSpinner.hide()
                }
            }
        }
    }
    
    @objc func createTweet() {
        debugPrint("it works")
        let twitterUrl = "https://twitter.com/intent/tweet?text=The current temperature at " + self.city + " is 72 ˚F. The weather conditions are sunny.&hashtags=CSCI571WeatherSearch"
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

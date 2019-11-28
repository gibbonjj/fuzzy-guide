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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            }
            else {
                let jsonUnwrapped = JSON(json)
                if(jsonUnwrapped["status"].stringValue == "OK") {
                    let currently = jsonUnwrapped["currently"]
                    let daily = jsonUnwrapped["daily"]
                    debugPrint(currently)
                }
                else {
                    debugPrint("Error returning api")
                }
            }
        }
        SwiftSpinner.hide()
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

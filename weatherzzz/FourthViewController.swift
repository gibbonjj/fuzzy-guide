//
//  FourthViewController.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/30/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class FourthViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    @IBOutlet weak var mainDataLanding: UIView!

    @IBOutlet weak var weeklyDataTable: UITableView!

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentWindSpeed: UILabel!
    @IBOutlet weak var currentVisbility: UILabel!
    @IBOutlet weak var currentPressure: UILabel!
    
    @IBOutlet weak var weeklySum: UIImageView!
    

    var weeklyDataCells = [CellData]()
    private let networkClient = NetworkClient()
    
    var cities: [String] = Array()
    var city: String = ""
    var state: String = ""
    let textViewController = UITextView()
    var lat: Double = 0.0
    var long: Double = 0.0
    var localData: JSON = [:]
    var time: Double = 0.0

    var localCity: String = ""
    
    var weeklyData:JSON = [:]
    var currentlyData:JSON = [:]
    var dailyData:JSON = [:]

    var allData:JSON = [:]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Weather Details for " + self.city + "...")
        
        if let savedCities = UserDefaults.standard.dictionary(forKey: "savedCities") {
            if savedCities[self.city + "," + self.state] != nil {
                self.favButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            }
        }
        
        //****** DataCell
        weeklyDataTable.dataSource = self
        weeklyDataTable.delegate = self
        let weekCell = UINib(nibName: "WeeklyData", bundle: nil)
        weeklyDataTable.register(weekCell, forCellReuseIdentifier: "WeekData")
        
        navigationItem.title = self.city

        let localLink: String = "https://weatherservice571.azurewebsites.net/street/*/" + "city/" + self.city + "/state/" + self.state
        let encodedLink: String = localLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let localUrl = URL(string: encodedLink) else {
            return
        }
        
        networkClient.fetch(localUrl) { (json, error) in
            if error != nil {
                debugPrint(error)
                SwiftSpinner.hide()
            } else {
                self.localData = json!
                let jsonUnwrapped = JSON(json)
                self.weeklyData = jsonUnwrapped["daily"]["data"]
                self.dailyData = jsonUnwrapped["daily"]
                self.currentlyData = jsonUnwrapped["currently"]
                let icon = self.currentlyData["icon"].string!.lowercased()
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
                
                if let summary = self.currentlyData["summary"].string {
                    self.currentStatus.text = summary
                }
                
                if let currentTemp = self.currentlyData["temperature"].double {
                    self.currentTemp.text = String(Int(currentTemp.rounded())) + " ˚F"
                }
                
                if let currentHumidity = self.currentlyData["humidity"].double {
                    self.currentHumidity.text = String((currentHumidity * 100.0).rounded()) + " %"
                }
                
                if let currentWind = self.currentlyData["windSpeed"].double {
                    self.currentWindSpeed.text = String(format: "%.2f", currentWind) + " mph"
                }
                
                if let currentVis = self.currentlyData["visibility"].double {
                    self.currentVisbility.text = String(format: "%.2f", currentVis) + " km"
                }
                
                if let currentPres = self.currentlyData["pressure"].double {
                    self.currentPressure.text = String(format: "%.1f", currentPres) + " mb"
                }
                
                self.currentLocation.text = self.city
                
                
                DispatchQueue.main.async {
                    self.weeklyDataTable.reloadData()
                    SwiftSpinner.hide()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == weeklyDataTable {
            if let weeklyCountArray = self.weeklyData["data"].array {
                let weeklyCount = weeklyCountArray.count
                
                return weeklyCount
            }
            else {
                return 7
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == weeklyDataTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekData") as! WeeklyData
            
            if let unixTime = self.weeklyData[indexPath.row]["time"].double {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyy"
                cell.weekDate.text = formatter.string(from: NSDate(timeIntervalSince1970: unixTime) as Date)
            }
            
            if let sunsetTime = self.weeklyData[indexPath.row]["sunsetTime"].double {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                cell.weekSunUp.text = formatter.string(from: NSDate(timeIntervalSince1970: sunsetTime) as Date)
            }
            
            if let sunriseTime = self.weeklyData[indexPath.row]["sunriseTime"].double {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                cell.weekSunDown.text = formatter.string(from: NSDate(timeIntervalSince1970: sunriseTime) as Date)
            }
            
            let icon = self.weeklyData[indexPath.row]["icon"]
            if(icon == "partly-cloudy-night") {
                let img = UIImage(named: "weather-night-partly-cloudy")
                cell.weekSummary.image = img
            }
            else if (icon == "clear-day") {
                let img = UIImage(named: "weather-sunny")
                cell.weekSummary.image = img
            }
            else if (icon == "rain") {
                let img = UIImage(named: "weather-rainy")
                cell.weekSummary.image = img
            }
            else if (icon == "snow") {
                let img = UIImage(named: "weather-snowy")
                cell.weekSummary.image = img
            }
            else if (icon == "sleet") {
                let img = UIImage(named: "weather-snowy-rainy")
                cell.weekSummary.image = img
            }
            else if (icon == "wind") {
                let img = UIImage(named: "weather-windy")
                cell.weekSummary.image = img
            }
            else if (icon == "fog") {
                let img = UIImage(named: "weather-fog")
                cell.weekSummary.image = img
            }
            else if (icon == "cloudy") {
                let img = UIImage(named: "weather-cloudy")
                cell.weekSummary.image = img
            }
            else if (icon == "partly-cloudy-day") {
                let img = UIImage(named: "weather-partly-cloudy")
                cell.weekSummary.image = img
            }
            
            cell.layoutIfNeeded()
            return cell as UITableViewCell
        }
        else {
            return UITableViewCell()
        }
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        let defaults = UserDefaults.standard

        if let cityFav = defaults.data(forKey: self.city + "," + self.state) {
            self.favButton.transform = .identity
            defaults.removeObject(forKey: self.city + "," + self.state)
            if var savedCities = defaults.dictionary(forKey: "savedCities") {
                savedCities[self.city + "," + self.state] = nil
                defaults.set(savedCities, forKey: "savedCities")
            }
            self.view.makeToast(self.city + " was removed from the Favorite List")
        }
        else {
            do {
                let encryptedData: Data = try self.localData.rawData()
                UserDefaults.standard.set(encryptedData, forKey: self.city + "," + self.state)
                if var savedCities = defaults.dictionary(forKey: "savedCities") {
                    savedCities[self.city + "," + self.state] = 1
                    defaults.set(savedCities, forKey: "savedCities")
                } else {
                    var savedCities = Dictionary<String, Int>()
                    savedCities[self.city + "," + self.state] = 1
                    defaults.set(savedCities, forKey: "savedCities")
                }
            } catch {
                debugPrint("error")
            }
                
            
            
            self.favButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            self.view.makeToast(self.city + " was added to the Favorite List")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cityDataClick") {
            let barViewControllers = segue.destination as! UITabBarController
            let destinationViewController = barViewControllers.viewControllers![0] as! SecondViewController
            destinationViewController.city = self.city
            destinationViewController.state = self.state
            destinationViewController.currently = self.currentlyData
            destinationViewController.daily = self.weeklyData
            destinationViewController.weatherTemp = self.currentTemp.text!
            destinationViewController.weatherCondition = self.currentStatus.text!
            let thirdViewController = barViewControllers.viewControllers![2] as! ThirdViewController
            thirdViewController.city = self.city
            thirdViewController.state = self.state
            thirdViewController.weatherTemp = self.currentTemp.text!
            thirdViewController.weatherCondition = self.currentStatus.text!
            let firstController = barViewControllers.viewControllers![1] as! FirstViewController
            firstController.daily = self.dailyData
            firstController.city = self.city
            firstController.weatherTemp = self.currentTemp.text!
            firstController.weatherCondition = self.currentStatus.text!
        }
    }
}

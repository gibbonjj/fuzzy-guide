//
//  ViewController.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/24/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON
import SwiftSpinner

struct CellData {
    let date: String
    let forecastImg: UIImage
    let sunUpTime: String
    let sunUpImg: UIImage
    let sunDownTime: String
    let sunDownImg: UIImage
}

struct DataCell {
    
}

class ViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate  {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var mainDataLanding: UIView!
    @IBOutlet weak var cityList: UITableView!
    @IBOutlet weak var weeklyDataTable: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentWindSpeed: UILabel!
    @IBOutlet weak var currentVisbility: UILabel!
    @IBOutlet weak var currentPressure: UILabel!
    
    @IBOutlet weak var weeklySum: UIImageView!

    let searchController = UISearchController(searchResultsController: nil)
    var weeklyDataCells = [CellData]()
    private let networkClient = NetworkClient()
    private let locationManager = CLLocationManager()

    var cities: [String] = Array()
    var city: String = ""
    var state: String = ""
    let textViewController = UITextView()
    var lat: Double = 0.0
    var long: Double = 0.0
    var localData: JSON = [:]
    var time: Double = 0.0
    var frame = CGRect(x:0,y:0,width:0,height:0)
    let autoCompleteUrl = "https://weatherservice571.azurewebsites.net/"
    var localCity: String = ""
    
    var weeklyData:JSON = [:]
    var currentlyData:JSON = [:]
    var dailyData:JSON = [:]
    
    var searchCity: String = ""
    var searchState: String = ""
    
    

    override func viewWillAppear(_ animated: Bool) {
        SwiftSpinner.show("Loading...")
        //** Location **
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        scrollView.delegate = self
        pageControl.numberOfPages = 1
        var savedViews: [JSON] = []
        
        let defaults = UserDefaults.standard
        if let savedCities = defaults.dictionary(forKey: "savedCities") {
            debugPrint(savedCities)
            for (key, value) in savedCities {
                do {
                    let encryptedDataArray = try JSON(data: defaults.data(forKey: key)!)
                    debugPrint("yes")
                    savedViews.append(encryptedDataArray)
                } catch {
                    debugPrint("error")
                }
            }
        }
        
        for index in 0..<savedViews.count {
            pageControl.numberOfPages = pageControl.numberOfPages + 1
            frame.origin.x = scrollView.frame.size.width * CGFloat(index + 1)
            frame.size = scrollView.frame.size
            let homeView = HomeView(frame: frame)
            self.scrollView.addSubview(homeView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(savedViews.count + 1)), height: scrollView.frame.size.height)
        
        if let lastLocation = locationManager.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: {(placemarks, error) in
                if error == nil {
                    let loc = placemarks?[0]
                    debugPrint(loc?.locality)
                    if let localCity = loc?.locality {
                        self.localCity = localCity
                        self.currentLocation.text = localCity
                    }
                    
                    // completionHandler(loc)
                }
                else {
                    //completionHandler(nil)
                }
            })
        }
        
        
        
        //****** DataCell
        let weekCell = UINib(nibName: "WeeklyData", bundle: nil)
        weeklyDataTable.register(weekCell, forCellReuseIdentifier: "WeekData")
        weeklyDataTable.dataSource = self
        weeklyDataTable.delegate = self
        //self.weeklyDataTable.layoutIfNeeded()
        
        
        //** SearchBar **
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        let citySearchBar = searchController.searchBar
        citySearchBar.delegate = self
        citySearchBar.placeholder = "Enter City Name..."
        self.navigationItem.titleView = citySearchBar
        
        
        self.definesPresentationContext = true
        
        //** SearchList UITableView 1**
        cityList.dataSource = self
        cityList.layoutIfNeeded()
        cityList.delegate = self
        cityList.layer.cornerRadius = CGFloat(7.0)
        cityList.isHidden = true
        cities.append("Los Angeles")
        cities.append("Las Vegas")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDataLanding.layer.masksToBounds = true
        mainDataLanding.layer.borderWidth = 1.5
        mainDataLanding.layer.borderColor = UIColor.white.cgColor
        mainDataLanding.layer.cornerRadius = 10.0
        
        weeklyDataTable.layer.masksToBounds = true
        weeklyDataTable.layer.borderWidth = 1.5
        weeklyDataTable.layer.borderColor = UIColor.white.cgColor
        weeklyDataTable.layer.cornerRadius = 10.0
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let getUrl = URL(string: autoCompleteUrl + searchText) else {
            return
        }
        if(searchText != "") {
            
        
        networkClient.fetch(getUrl) { (json, error) in
            if let error = error {
                self.cityList.isHidden = true
                debugPrint(error)
            }
            else {
                let jsonUnwrapped = JSON(json)
                self.cities.removeAll()
                if(jsonUnwrapped["status"].stringValue == "OK") {
                    for prediction in jsonUnwrapped["predictions"].arrayValue {
                        let description = prediction["description"].stringValue
                        self.cities.append(description)
                    }
                    self.cityList.reloadData()
                    self.cityList.isHidden = false
                }
                else {
                    self.cityList.isHidden = true
                }
            }
        debugPrint(searchText)
        debugPrint(self.cities)
        }
        }
        else {
            self.cityList.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cityList {
            return cities.count
        }
        else if tableView == weeklyDataTable {
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
        if tableView == cityList {
        var cell = tableView.dequeueReusableCell(withIdentifier: "city")
        if cell == nil {
            cell = UITableViewCell()
        }
        cell?.textLabel?.text = cities[indexPath.row]
        return cell!
        }
        else if tableView == weeklyDataTable {

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cityList {
        let cityString = self.cities[indexPath.row]
        let cityArray = cityString.components(separatedBy: ", ")
        self.searchCity = cityArray[0]
        self.searchState = cityArray[1]
        self.cities.removeAll()
        self.performSegue(withIdentifier: "cityClick", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cityClick") {
            
            let fourthViewController = segue.destination as! FourthViewController
            fourthViewController.city = self.searchCity
            fourthViewController.state = self.searchState
        }
        else if(segue.identifier == "localClick") {

            let barViewControllers = segue.destination as! UITabBarController
            let destinationViewController = barViewControllers.viewControllers![0] as! SecondViewController
            destinationViewController.city = self.localCity
            destinationViewController.state = self.state
            destinationViewController.currently = self.currentlyData
            destinationViewController.daily = self.weeklyData
            let thirdViewController = barViewControllers.viewControllers![2] as! ThirdViewController
            thirdViewController.city = self.localCity
            thirdViewController.state = self.state
            let firstController = barViewControllers.viewControllers![1] as! FirstViewController
            firstController.daily = self.dailyData
            firstController.city = self.city
        }
    }

}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!

        self.lat = lastLocation.coordinate.latitude
        self.long = lastLocation.coordinate.longitude
        self.time = lastLocation.timestamp.timeIntervalSince1970

        
        let localLink: String = "https://weatherservice571.azurewebsites.net/weekly/" + String(self.lat) + "/" + String(self.long)

        guard let localUrl = URL(string: localLink) else {
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
                    self.currentTemp.text = String(Int(currentTemp.rounded())) + "˚F"
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
                
        
                DispatchQueue.main.async {
                    self.weeklyDataTable.reloadData()
                    SwiftSpinner.hide()
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}

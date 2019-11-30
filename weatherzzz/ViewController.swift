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

struct CellData {
    let date: String
    let forecastImg: UIImage
    let sunUpTime: String
    let sunUpImg: UIImage
    let sunDownTime: String
    let sunDownImg: UIImage
}

class ViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate  {
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var mainDataLanding: UIView!

    let searchController = UISearchController(searchResultsController: nil)

    var weeklyDataCells = [CellData]()
    private let networkClient = NetworkClient()
    private let locationManager = CLLocationManager()
    @IBOutlet weak var cityList: UITableView!
    @IBOutlet weak var weeklyDataTable: UITableView!
    var weeklyData:JSON = [:]
    
    var cities: [String] = Array()
    var city: String = ""
    var state: String = ""
    let textViewController = UITextView()
    var lat: Double = 0.0
    var long: Double = 0.0
    var localData: JSON = [:]
    var time: Double = 0.0
    var frame = CGRect(x:0,y:0,width:0,height:0)

    @IBOutlet weak var scrollView: UIScrollView!
    

    let autoCompleteUrl = "https://weatherservice571.azurewebsites.net/"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //******** PageControl
        
        pageControl.numberOfPages = 4
        for index in 0..<4 {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(4)), height: scrollView.frame.size.height)
        
        scrollView.delegate = self

        
        //****** DataCell
        weeklyDataTable.register(CustomCell.self, forCellReuseIdentifier: "custom")
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

        
        //** Location **
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        guard let getUrl = URL(string: "https://weatherservice571.azurewebsites.net/street/819%20Santee%20St/city/Los%20Angeles/state/California") else {
            return
        }
        networkClient.fetch(getUrl) { (json, error) in
            if error != nil {
                
            } else {
                 // debugPrint(json)
            }
        }
        
        //** UITableViewTwo
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
                return 0
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

            let cell = tableView.dequeueReusableCell(withIdentifier: "customWeekCell")
      
            // cell?.textLabel?.text = cities[indexPath.row]
//            if let unixTime = self.weeklyData["data"][indexPath.row]["time"].double {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "MM/dd/yyyy"
//                cell.date = formatter.string(from: NSDate(timeIntervalSince1970: unixTime) as Date)
//
//            }
//            cell.forecastImg = UIImage(named: "weather-windy50") //weather-sunset-up
//            cell.sunDownImg = UIImage(named: "weather-sunset-down")
//            cell.sunUpImg = UIImage(named: "weather-sunset-up")
//            if let sunsetTime = self.weeklyData["data"][indexPath.row]["sunsetTime"].double {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "HH:mm"
//                cell.sunDownTime = formatter.string(from: NSDate(timeIntervalSince1970: sunsetTime) as Date)
//            }
//            if let sunriseTime = self.weeklyData["data"][indexPath.row]["sunriseTime"].double {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "HH:mm"
//                cell.sunUpTime = formatter.string(from: NSDate(timeIntervalSince1970: sunriseTime) as Date)
//            }
//            debugPrint(cell.sunDownTime)
//            cell.layoutIfNeeded()
            return cell!
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cityList {
        let cityString = self.cities[indexPath.row]
        let cityArray = cityString.components(separatedBy: ", ")
        self.city = cityArray[0]
        self.state = cityArray[1]
        self.performSegue(withIdentifier: "cityClick", sender: self)

        self.cities.removeAll()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cityClick") {
            let barViewControllers = segue.destination as! UITabBarController
            let destinationViewController = barViewControllers.viewControllers![0] as! SecondViewController
            destinationViewController.city = self.city
            destinationViewController.state = self.state
            let thirdViewController = barViewControllers.viewControllers![2] as! ThirdViewController
            thirdViewController.city = self.city
            thirdViewController.state = self.state
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
            } else {
                self.localData = json!
                let jsonUnwrapped = JSON(json)
                self.weeklyData = jsonUnwrapped["daily"]
                DispatchQueue.main.async {
                    self.weeklyDataTable.reloadData()
                }
            }
        }
        // Do something with the location.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}

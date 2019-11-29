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

class ViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var mainDataLanding: UIView!
    let searchController = UISearchController(searchResultsController: nil)

    
    private let networkClient = NetworkClient()
    private let locationManager = CLLocationManager()
    @IBOutlet weak var cityList: UITableView!
    
    var cities: [String] = Array()
    var city: String = ""
    var state: String = ""
    let textViewController = UITextView()
    var lat: Double = 0.0
    var long: Double = 0.0
    var localData: JSON = [:]

    
    let autoCompleteUrl = "https://weatherservice571.azurewebsites.net/"

    
    override func viewDidLoad() {
        super.viewDidLoad()

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

        debugPrint(citySearchBar.text?.count)
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
        else {
            return 7
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
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "city")
            if cell == nil {
                cell = UITableViewCell()
            }
            cell?.textLabel?.text = cities[indexPath.row]
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cityList {
        let cityString = self.cities[indexPath.row]
        let cityArray = cityString.components(separatedBy: ", ")
        self.city = cityArray[0]
        self.state = cityArray[1]
        self.performSegue(withIdentifier: "cityClick", sender: self)
        debugPrint(" has been selected " + self.city + " " + self.state)
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
        debugPrint("hello")
        self.lat = lastLocation.coordinate.latitude
        self.long = lastLocation.coordinate.longitude
        debugPrint(lastLocation.coordinate.latitude)
        debugPrint(lastLocation.coordinate.longitude)
        
        let localLink: String = "https://weatherservice571.azurewebsites.net/lat/" + String(self.lat) + "/long/" + String(self.long)
        debugPrint(localLink)
        guard let localUrl = URL(string: localLink) else {
            return
        }
        
        networkClient.fetch(localUrl) { (json, error) in
            if error != nil {
                debugPrint(error)
            } else {
                self.localData = json!
                debugPrint(self.localData)
            }
        }
        // Do something with the location.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}

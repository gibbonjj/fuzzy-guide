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

        //** SearchList **
        cityList.dataSource = self
        cityList.layoutIfNeeded()
        cityList.delegate = self
        cityList.layer.cornerRadius = CGFloat(7.0)
        cityList.isHidden = true
        cities.append("Los Angeles")
        cities.append("Las Vegas")

        
        //** Location **
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        

        guard let getUrl = URL(string: "https://weatherservice571.azurewebsites.net/street/819%20Santee%20St/city/Los%20Angeles/state/California") else {
            return
        }
        networkClient.fetch(getUrl) { (json, error) in
            if error != nil {
                
            } else {
                 // debugPrint(json)
            }
        }
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
        
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "city")
        if cell == nil {
            cell = UITableViewCell()
        }
        cell?.textLabel?.text = cities[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityString = self.cities[indexPath.row]
        let cityArray = cityString.components(separatedBy: ", ")
        self.city = cityArray[0]
        self.state = cityArray[1]
        self.performSegue(withIdentifier: "cityClick", sender: self)
        debugPrint(" has been selected " + self.city + " " + self.state)
        self.cities.removeAll()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cityClick") {
        let barViewControllers = segue.destination as! UITabBarController
        let destinationViewController = barViewControllers.viewControllers![0] as! SecondViewController
        destinationViewController.city = self.city
        destinationViewController.state = self.state
        }
    }

}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        debugPrint(lastLocation)
        // Do something with the location.
    }
}

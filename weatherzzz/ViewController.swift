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
    let textViewController = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //** SearchBar **
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true

        //** SearchList **
        cityList.dataSource = self
        cityList.layoutIfNeeded()
        cityList.layer.cornerRadius = CGFloat(7.0)
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
            if let error = error {
                
            } else {
                 debugPrint(json)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    
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

}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        debugPrint(lastLocation)
        // Do something with the location.
    }
}

//
//  HomeView.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/30/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import UIKit
import SwiftyJSON


class HomeView: UIView {

    @IBOutlet weak var removeFavButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var weatherLoc: UILabel!
    @IBOutlet weak var weatherHumidity: UILabel!
    @IBOutlet weak var weatherWindSpeed: UILabel!
    @IBOutlet weak var weatherVisibility: UILabel!
    @IBOutlet weak var weatherPressure: UILabel!
    @IBOutlet weak var weeklyDataTable: UITableView!
    var favIndex: Int = 0
    var weeklyData:JSON = [:]
    var currentlyData:JSON = [:]
    var dailyData:JSON = [:]
    var localData:JSON = [:]
    
    var searchCity: String = ""
    var searchState: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @IBAction func removeFavorite(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if let cityFav = defaults.data(forKey: self.searchCity + "," + self.searchState) {
            defaults.removeObject(forKey: self.searchCity + "," + self.searchState)
            if var savedCities = defaults.dictionary(forKey: "savedCities") {
                savedCities[self.searchCity + "," + self.searchState] = nil
                defaults.set(savedCities, forKey: "savedCities")
            }
            //let notification = NotificationCenter.defaultCen
            debugPrint("deleted it")
            let deleteCity = [self.searchCity : self.searchState]
            NotificationCenter.default.post(name: .didRemoveFave, object: nil, userInfo: deleteCity)
            
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}

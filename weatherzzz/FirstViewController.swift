//
//  FirstViewController.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/24/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class FirstViewController: UIViewController, ChartViewDelegate{

    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var weeklySum: UIImageView!
    // https://www.iosapptemplates.com/blog/swift-programming/ios-charts-swift
    @IBOutlet weak var lineChartView: LineChartView!
    var daily: JSON = [:]
    var city: String = ""
    var icon: String = ""
    var weatherTemp: String = ""
    var weatherCondition: String = ""
    // var summary: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = self.city
        let twitterImg: UIImage = UIImage(named: "twitter.png")!
        let tweetButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        tweetButton.setImage(twitterImg, for: .normal)
        tweetButton.addTarget(self, action: #selector(FirstViewController.createTweet), for: .touchUpInside)
        let twitterButton = UIBarButtonItem(customView: tweetButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = twitterButton
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.city
        if let icon = self.daily["icon"].string {
            self.icon = icon
        }
        if let summary = self.daily["summary"].string {
            self.summary.text = summary
        }
        debugPrint("+++++" + icon)
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

        var days: [Int] = []
        var minTemps: [Double] = []
        var maxTemps: [Double] = []
        var indexCount: Int = 0
        
        let dayData = self.daily["data"].arrayValue
        for day in dayData {
            let minTemp: Double = day["temperatureMin"].doubleValue
            minTemps.append(minTemp.rounded())
            let maxTemp: Double = day["temperatureHigh"].doubleValue
            maxTemps.append(maxTemp.rounded())
            days.append(indexCount)
            indexCount += 1
        }
        buildChart(dataPoints: days, minValues: minTemps, maxValues: maxTemps)
    
    }
    
    func buildChart(dataPoints: [Int], minValues: [Double], maxValues: [Double]) {
        var minDataEntries: [ChartDataEntry] = []
        var maxDataEntries: [ChartDataEntry] = []
        let data = LineChartData()
        
        for i in 0..<dataPoints.count {
            let minDataEntry = ChartDataEntry(x: Double(dataPoints[i]), y: minValues[i])
            minDataEntries.append(minDataEntry)
            let maxDataEntry = ChartDataEntry(x: Double(dataPoints[i]), y: maxValues[i])
            maxDataEntries.append(maxDataEntry)
        }
        
        let minLabel = "Minimum Temperature (˚F)"
        let maxLabel = "Maximum Temperature (˚F)"
        
        let minData = LineChartDataSet(entries: minDataEntries, label: minLabel)
        let maxData = LineChartDataSet(entries: maxDataEntries, label: maxLabel)
        minData.drawCircleHoleEnabled = false
        maxData.drawCircleHoleEnabled = false
        minData.circleRadius = CGFloat(5.0)
        maxData.circleRadius = CGFloat(5.0)
        maxData.setColor(NSUIColor(red: 255.0/255.0, green: 165.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        minData.setColor(NSUIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0))
        maxData.setCircleColor(NSUIColor(red: 255.0/255.0, green: 165.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        minData.setCircleColor(NSUIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0))

        data.addDataSet(minData)
        data.addDataSet(maxData)
        self.lineChartView.data = data
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
}

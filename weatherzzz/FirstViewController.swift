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

    // https://www.iosapptemplates.com/blog/swift-programming/ios-charts-swift
    @IBOutlet weak var lineChartView: LineChartView!
    var daily: JSON = [:]
    var city: String = ""
    
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
        data.addDataSet(minData)
        data.addDataSet(maxData)
        self.lineChartView.data = data
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
}

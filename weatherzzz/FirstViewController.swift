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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(self.daily)
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
    
}

//
//  ThirdViewController.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/24/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class ThirdViewController: UIViewController, UIScrollViewDelegate {
    
    var city: String = ""
    var state: String = ""
    var images: [String] = []
    var frame = CGRect(x:0,y:0,width:0,height:0)
    var weatherTemp: String = ""
    var weatherCondition: String = ""

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = self.city
        let twitterImg: UIImage = UIImage(named: "twitter.png")!
        let tweetButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        tweetButton.setImage(twitterImg, for: .normal)
        tweetButton.addTarget(self, action: #selector(ThirdViewController.createTweet), for: .touchUpInside)
        let twitterButton = UIBarButtonItem(customView: tweetButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = twitterButton
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Google Images...")
        scrollView.delegate = self
        let networkClient = NetworkClient()
        let photoUrl: String = "https://www.googleapis.com/customsearch/v1?q=" + self.city + "&cx=014166346711985750812:pwxt4cd5lvz&imgSize=huge&imgType=news&num=5&searchType=image&key=AIzaSyA4KvwcgVa7S8705sX-fiA8Evoj8Rgi41k"
        
        let encodedPhotoUrl = photoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        guard let photoLink = URL(string: encodedPhotoUrl!) else {
            return
        }
        
        networkClient.fetch(photoLink) { (json, error) in
            if error != nil {
                debugPrint(error)
                SwiftSpinner.hide()
            } else {
                let jsonUnwrapped = JSON(json)
                if let items = jsonUnwrapped["items"].array {
                    
                    for index in 0..<items.count {
                        if let itemLink = items[index]["link"].string {
                            self.images.append(itemLink)
                        }
                    }
                    
                    var picCount = 0
                    for index in 0..<self.images.count {
                        
                        let imgURL = URL(string: self.images[index])
                        if let imgData = try? Data(contentsOf: imgURL!) {
                            self.frame.origin.y = self.scrollView.frame.size.height * CGFloat(Double(picCount) * 0.75)
                            self.frame.size.width = self.scrollView.frame.size.width
                            self.frame.size.height = self.scrollView.frame.size.height * 0.75
                            let img = UIImageView(frame: self.frame)
                            let uiImg = UIImage(data: imgData)
                            debugPrint(uiImg)
                            img.image = uiImg
                            self.scrollView.addSubview(img)
                            picCount = picCount + 1
                        }
                        
                    }
                    self.scrollView.contentSize = CGSize(width: (self.scrollView.frame.size.width), height: self.scrollView.frame.size.height * CGFloat(picCount) * 0.75)
                }
                debugPrint(self.images)
                SwiftSpinner.hide()
                
            }
        }
        
//        for index in 0..<images.count {
//            frame.origin.x = scrollView.frame.size.height * CGFloat(index)
//            frame.size = scrollView.frame.size
//        }

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

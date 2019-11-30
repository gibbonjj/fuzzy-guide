//
//  ThirdViewController.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/24/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var city: String = ""
    var state: String = ""
    var images: [String] = ["0", "1", "2"]
    var frame = CGRect(x:0,y:0,width:0,height:0)
    
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
        
        let networkClient = NetworkClient()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.height * CGFloat(index)
            frame.size = scrollView.frame.size
        }

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

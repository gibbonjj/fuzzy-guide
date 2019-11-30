//
//  CustomCell.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/29/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    var date: String?
    var forecastImg: UIImage?
    var sunUpTime: String?
    var sunUpImg: UIImage?
    var sunDownTime: String?
    var sunDownImg: UIImage?
    
    var dateView: UILabel =  {
        var textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return textView
    }()
    
    var foreCastImgView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var sunUpTimeView: UILabel =  {
        var textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var sunUpImgView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var sunDownTimeView: UILabel =  {
        var textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var sunDownImgView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(dateView)
        self.addSubview(foreCastImgView)
        self.addSubview(sunUpTimeView)
        self.addSubview(sunUpImgView)
        self.addSubview(sunDownTimeView)
        self.addSubview(sunDownImgView)
        
        dateView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dateView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dateView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dateView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dateView.widthAnchor.constraint(equalToConstant: 10.0)
        
        
        foreCastImgView.leftAnchor.constraint(equalTo: self.dateView.rightAnchor).isActive = true
        foreCastImgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        foreCastImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        foreCastImgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        sunUpTimeView.leftAnchor.constraint(equalTo: self.foreCastImgView.rightAnchor).isActive = true
        sunUpTimeView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sunUpTimeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sunUpTimeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        sunUpImgView.leftAnchor.constraint(equalTo: self.sunUpTimeView.rightAnchor).isActive = true
        sunUpImgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sunUpImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sunUpImgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        sunDownTimeView.leftAnchor.constraint(equalTo: self.sunUpImgView.rightAnchor).isActive = true
        sunDownTimeView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sunDownTimeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sunDownTimeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        sunDownImgView.leftAnchor.constraint(equalTo: self.sunDownTimeView.rightAnchor).isActive = true
        sunDownImgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sunDownImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sunDownImgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let date = date {
            dateView.text = date
        }
        if let sunUpTime = sunUpTime {
            sunUpTimeView.text = sunUpTime
        }
        if let sunDownTime = sunDownTime {
            sunDownTimeView.text = sunDownTime
        }
        if let forecastImg = forecastImg {
            foreCastImgView.image = forecastImg
        }
        if let sunUpImg = sunUpImg {
            sunUpImgView.image = sunUpImg
        }
        if let sunDownImg = sunDownImg {
            sunDownImgView.image = sunDownImg
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
}

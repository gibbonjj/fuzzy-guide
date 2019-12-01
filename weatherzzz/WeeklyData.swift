//
//  WeeklyData.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/30/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import UIKit

class WeeklyData: UITableViewCell {
    
    @IBOutlet weak var weekDate: UILabel!
    @IBOutlet weak var weekSunUp: UILabel!
    @IBOutlet weak var weekSunDown: UILabel!
    
    @IBOutlet weak var weekSummary: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

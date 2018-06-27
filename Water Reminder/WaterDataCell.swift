//
//  WaterDataCell.swift
//  Water Reminder
//
//  Created by ShiFayChy on 2018/6/25.
//  Copyright © 2018年 Lin Jin An. All rights reserved.
//

import UIKit

class WaterDataCell: UITableViewCell {
    @IBOutlet weak var DrinkTimeLabel: UILabel!
    @IBOutlet weak var DrinkAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

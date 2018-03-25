//
//  RestaurantDetailTableViewCell.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 16.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit

class RestaurantDetailTableViewCell: UITableViewCell{
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

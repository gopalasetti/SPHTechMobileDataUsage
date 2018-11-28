//
//  QuarterDataCell.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//

import UIKit

class QuarterDataCell: UITableViewCell {

    @IBOutlet weak var quarterName: UILabel!
    
    @IBOutlet weak var dataUsageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  YearDataCell.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//

import UIKit

protocol YearCellDelegate {
    
    /// TO Display the list of quarters
    ///
    /// - Parameter index: index of the year
    func infoBtnClicked(index: Int)
    
}

class YearDataCell: UITableViewCell {

    @IBOutlet weak var yearNameLbl: UILabel!
    
    @IBOutlet weak var dataUsageLbl: UILabel!
    
    @IBOutlet weak var detailsOfYearBtn: UIButton!
    
    var delegate: YearCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func showDetailsOfYearBtnAction(_ sender: Any) {
        delegate?.infoBtnClicked(index: self.tag)
    }
    
    
    /// Update the details of year
    ///
    /// - Parameter year: year object
    func updateYearDetails(_ year: Year) {
        let querters = year.quarter?.allObjects as? [Quarter]
        var data = 0.0
        for querter in querters! {
            data += querter.data
        }
        let finalDataUSage = String(format: "%.6f", data)
        yearNameLbl.text = "\(year.name)"
        dataUsageLbl.text = "\(finalDataUSage)"
        if isQuartersDataDecreasedInYear(year: year) {
            detailsOfYearBtn.isHidden = false
        } else {
            detailsOfYearBtn.isHidden = true
        }
    }
    
    
    /// To identify weather the quarter data is in decreasing order
    ///
    /// - Parameter year: year
    /// - Returns: returns true if it is in decreasing order, returns false if it is is increasing order
    func isQuartersDataDecreasedInYear(year: Year) -> Bool {
        let quarters = year.quarter?.allObjects as? [Quarter] ?? []
        var orderedQuarters: [Quarter] = quarters
        for quarter in quarters {
            switch quarter.name {
            case "Q1":
                orderedQuarters[0] = quarter
            case "Q2":
                orderedQuarters[1] = quarter
            case "Q3":
                orderedQuarters[2] = quarter
            case "Q4":
                orderedQuarters[3] = quarter
            default:
                break
            }
        }
        for index in 0..<orderedQuarters.count - 1 {
            if orderedQuarters[index].data > orderedQuarters[index+1].data {
                return true
            }
        }
        return false
    }

}

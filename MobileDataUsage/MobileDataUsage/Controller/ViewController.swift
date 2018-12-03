//
//  ViewController.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YearCellDelegate {

    @IBOutlet weak var mobileDataUsageTableView: UITableView!
    
    var years : [Year]  = []

    var expandedSections : [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        mobileDataUsageTableView.tableFooterView = UIView()

        years = Year.fetchYear()
        
        mobileDataUsageTableView.layer.borderColor = UIColor.black.cgColor
        mobileDataUsageTableView.layer.borderWidth = 1.0
        
        getDataUsageFromServer { (response, json) in
            self.saveDataToDB(data: json as! [String : Any], handler: { (inserted) in
                self.years = Year.fetchYear()
                DispatchQueue.main.async {
                    self.mobileDataUsageTableView.reloadData()
                }
            })
        }
    }

    /// Get Data from server
    ///
    /// - Parameter handler: handel the response
    func getDataUsageFromServer(handler: @escaping (_ response: URLResponse?, _ json: Any) -> Void) {
        let url = URL(string: Constants.serviceURL)
        ServiceManager.get(url!, { (response, data) in
            handler(response, data)
        }) { (response, error) in
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    /// Parse the data and save records to DB
    ///
    /// - Parameter data: response Date
    func saveDataToDB(data: [String: Any], handler: @escaping (_ inserted: Bool) -> Void) {
        if let result = data["result"] as? [String: Any] {
            if let records = result["records"] as? [[String: Any]] {
                Year.addDataUsageRecords(records) { (inserted) in
                    handler(true)
                }
            }
        }
    }

    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return years.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSections.contains(section) {
            let querters = years[section].quarter?.allObjects as? [Quarter] ?? []
            return querters.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let yearView = tableView.dequeueReusableCell(withIdentifier: "YearDataCell") as! YearDataCell
        yearView.delegate = self
        yearView.updateYearDetails(years[section])
        yearView.tag = section
        return yearView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quarterCell = tableView.dequeueReusableCell(withIdentifier: "QuarterDataCell") as! QuarterDataCell
        if let quarter = Year.fetchQuarterByYearAndName(year: years[indexPath.section], quarterName: "Q\(indexPath.row+1)") {
            quarterCell.quarterName.text = quarter.name ?? ""
            quarterCell.dataUsageLbl.text = "\(quarter.data)"
        }
        return quarterCell
    }

    // MARK: - YearCellDelegate

    func infoBtnClicked(index: Int) {
        if expandedSections.contains(index) {
            expandedSections = expandedSections.filter{$0 != index}
        }
        else {
            expandedSections.append(index)
        }
        DispatchQueue.main.async {
            self.mobileDataUsageTableView.reloadData()
        }
    }

}


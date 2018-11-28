//
//  ViewController.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var years : [Year]  = []

    override func viewDidLoad() {
        super.viewDidLoad()

        years = Year.fetchYear()
        
        getDataUsageFromServer { (response, json) in
            self.saveDataToDB(data: json as! [String : Any])
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
            
        }
    }

    
    /// Parse the data and save records to DB
    ///
    /// - Parameter data: response Date
    func saveDataToDB(data: [String: Any]) {
        if let result = data["result"] as? [String: Any] {
            if let records = result["records"] as? [[String: Any]] {
                Year.addDataUsageRecords(records)
            }
        }
    }
    
}


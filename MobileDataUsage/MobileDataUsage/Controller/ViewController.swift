//
//  ViewController.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getDataUsageFromServer { (response, json) in
            print(json)
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

}


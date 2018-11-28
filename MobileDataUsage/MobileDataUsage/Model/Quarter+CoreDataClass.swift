//
//  Quarter+CoreDataClass.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Quarter)
public class Quarter: NSManagedObject {

    /// Get all the quarter info
    ///
    /// - Parameter preditcate: predicate to define the quarter identifier
    /// - Returns: return all the quarters of the identifier
    static func fetchQuarter(_ preditcate: NSPredicate) -> [Quarter] {
        var results: [Quarter] = []
        let request = NSFetchRequest<Quarter>(entityName: "Quarter")
        request.predicate = preditcate
        do {
            results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            return results
        }catch _ {
            print("Exception while retriving quarters data")
        }
        return results
    }

}

//
//  Year+CoreDataClass.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Year)
public class Year: NSManagedObject {

    
    /// Add the data usage records into DB
    ///
    /// - Parameter records: records from server
    static func addDataUsageRecords(_ records: [[String: Any]], handler: @escaping (_ inserted: Bool) -> Void) {
        
        let context = CoreDataStack.shared.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true

        context.perform {
            var listOfYears : [Year] = []
            for record in records {
                if let querterName = record["quarter"] as? String {
                    var quarter : Quarter? = nil
                    var year: Year? = nil
                    
                    //Year Record
                    if let name = querterName.components(separatedBy: "-").first {
                        let predicate = NSPredicate(format: "name = %d", Int(name)!)
                        let results = Year.fetchYear(predicate)
                        if results.count > 0 {
                            year = results.first!
                        }else {
                            for localYear in listOfYears {
                                if Int16(name) == localYear.name {
                                    year = localYear
                                    break
                                }
                            }
                            if year == nil {
                                let yearEntity = NSEntityDescription.entity(forEntityName: "Year", in: context)
                                year = Year(entity: yearEntity!, insertInto: context)
                            }
                            year!.name = Int16(name)!
                            listOfYears.append(year!)
                        }
                    }
                    
                    //Quarter Record
                    if let name = querterName.components(separatedBy: "-").last {
                        if let identifier = record["_id"] as? Int16 {
                            let predicate = NSPredicate(format: "identifier = %d", identifier)
                            let results = Quarter.fetchQuarter(predicate)
                            if results.count > 0 {
                                quarter = results.first!
                            }else {
                                let quarterEntity = NSEntityDescription.entity(forEntityName: "Quarter", in: context)
                                quarter = Quarter(entity: quarterEntity!, insertInto: context)
                                quarter?.name = name
                                quarter?.year = year
                                quarter?.identifier = identifier
                                year?.addToQuarter(quarter!)
                            }
                            let volume = record["volume_of_mobile_data"] as? String ?? ""
                            quarter?.data = Double(volume) ?? 0.0
                        }
                    }
                }
            }
            CoreDataStack.shared.saveContext(context: context)
            handler(true)
        }
    }
    
    
    /// Fetch all the years from the DB
    ///
    /// - Parameter preditcate: predicate to identify particular year if it is nill it will return all the records
    /// - Returns: returns all the records of the year
    static func fetchYear(_ preditcate: NSPredicate? = nil) -> [Year] {
        var results: [Year] = []
        let request = NSFetchRequest<Year>(entityName: "Year")
        let sort = NSSortDescriptor(key: #keyPath(Year.name), ascending: true)
        request.sortDescriptors = [sort]
        if preditcate != nil {
            request.predicate = preditcate
        }
        do {
            results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            return results
        }catch _ {
            print("Exception while retriving years data")
        }
        return results
    }

    /// To get the quarter based on the name and year
    ///
    /// - Parameters:
    ///   - year: year
    ///   - quarterName: name of the quarter
    /// - Returns: returns the quarter details
    static func fetchQuarterByYearAndName(year: Year, quarterName: String) -> Quarter? {
        let quarters = year.quarter?.allObjects as? [Quarter] ?? []
        for quarter in quarters {
            if quarter.name == quarterName {
                return quarter
            }
        }
        return nil
    }
}

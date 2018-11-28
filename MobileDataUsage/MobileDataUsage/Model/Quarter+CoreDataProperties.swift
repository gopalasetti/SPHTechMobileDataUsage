//
//  Quarter+CoreDataProperties.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//
//

import Foundation
import CoreData


extension Quarter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quarter> {
        return NSFetchRequest<Quarter>(entityName: "Quarter")
    }

    @NSManaged public var name: String?
    @NSManaged public var identifier: Int16
    @NSManaged public var data: Double
    @NSManaged public var year: Year?

}

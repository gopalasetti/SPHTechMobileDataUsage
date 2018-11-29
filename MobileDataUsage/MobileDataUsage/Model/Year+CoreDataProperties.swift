//
//  Year+CoreDataProperties.swift
//  MobileDataUsage
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//
//

import Foundation
import CoreData


extension Year {

    @NSManaged public var name: Int16
    @NSManaged public var quarter: NSSet?

}

// MARK: Generated accessors for quarter
extension Year {

    @objc(addQuarterObject:)
    @NSManaged public func addToQuarter(_ value: Quarter)

    @objc(removeQuarterObject:)
    @NSManaged public func removeFromQuarter(_ value: Quarter)

    @objc(addQuarter:)
    @NSManaged public func addToQuarter(_ values: NSSet)

    @objc(removeQuarter:)
    @NSManaged public func removeFromQuarter(_ values: NSSet)

}

//
//  Person+CoreDataProperties.swift
//  CoreData-CRUD
//
//  Created by Brian McIntosh on 12/24/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int64
    @NSManaged public var gender: String?
    @NSManaged public var name: String?

}

extension Person : Identifiable {

}

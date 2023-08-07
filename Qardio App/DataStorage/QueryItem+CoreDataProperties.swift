//
//  QueryItem+CoreDataProperties.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//
//

import Foundation
import CoreData


extension QueryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QueryItem> {
        return NSFetchRequest<QueryItem>(entityName: "QueryItem")
    }

    @NSManaged public var date: Date?
    @NSManaged public var query: String?

}

extension QueryItem : Identifiable {

}

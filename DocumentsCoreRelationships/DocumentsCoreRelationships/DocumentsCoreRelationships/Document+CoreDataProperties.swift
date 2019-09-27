//
//  Document+CoreDataProperties.swift
//  DocumentsCoreRelationships
//
//  Created by Alex Davis on 9/26/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var size: Int64
    @NSManaged public var rawModifiedDate: Date?
    @NSManaged public var content: String?
    @NSManaged public var name: String?
    @NSManaged public var category: Category?

}

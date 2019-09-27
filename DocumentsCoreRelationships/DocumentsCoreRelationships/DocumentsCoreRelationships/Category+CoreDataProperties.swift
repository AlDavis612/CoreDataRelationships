//
//  Category+CoreDataProperties.swift
//  DocumentsCoreRelationships
//
//  Created by Alex Davis on 9/26/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var document: NSOrderedSet?

}

// MARK: Generated accessors for document
extension Category {

    @objc(insertObject:inDocumentAtIndex:)
    @NSManaged public func insertIntoDocument(_ value: Document, at idx: Int)

    @objc(removeObjectFromDocumentAtIndex:)
    @NSManaged public func removeFromDocument(at idx: Int)

    @objc(insertDocument:atIndexes:)
    @NSManaged public func insertIntoDocument(_ values: [Document], at indexes: NSIndexSet)

    @objc(removeDocumentAtIndexes:)
    @NSManaged public func removeFromDocument(at indexes: NSIndexSet)

    @objc(replaceObjectInDocumentAtIndex:withObject:)
    @NSManaged public func replaceDocument(at idx: Int, with value: Document)

    @objc(replaceDocumentAtIndexes:withDocument:)
    @NSManaged public func replaceDocument(at indexes: NSIndexSet, with values: [Document])

    @objc(addDocumentObject:)
    @NSManaged public func addToDocument(_ value: Document)

    @objc(removeDocumentObject:)
    @NSManaged public func removeFromDocument(_ value: Document)

    @objc(addDocument:)
    @NSManaged public func addToDocument(_ values: NSOrderedSet)

    @objc(removeDocument:)
    @NSManaged public func removeFromDocument(_ values: NSOrderedSet)

}

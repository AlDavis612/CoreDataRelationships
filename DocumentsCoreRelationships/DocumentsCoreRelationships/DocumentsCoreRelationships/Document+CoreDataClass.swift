//
//  Document+CoreDataClass.swift
//  DocumentsCoreRelationships
//
//  Created by Alex Davis on 9/26/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Document)
public class Document: NSManagedObject {
    var ModDate: Date? {
        get {
            return rawModifiedDate as Date?
        }
        set {
            rawModifiedDate = newValue as NSDate? as Date? //Error for some reason without 'as Date?'
        }
    }
    
    convenience init?(name: String?, content: String?, category: Category) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Document.entity(), insertInto: managedContext)
        self.name = name
        self.content = content
        if let size = content?.count {
            self.size = Int64(size)
        } else {
            self.size = 0
        }
        self.ModDate = Date(timeIntervalSinceNow: 0)
        self.category = category
    }
    
    func update(name: String, content: String?, category: Category) {
        self.name = name
        self.content = content
        if let size = content?.count {
            self.size = Int64(size)
        } else {
            self.size = 0
        }
        self.ModDate = Date(timeIntervalSinceNow: 0)
        self.category = category
    }

}

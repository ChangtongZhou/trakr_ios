//
//  User+CoreDataProperties.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/20/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var name: String?
    @NSManaged var isLogin: NSNumber?

}

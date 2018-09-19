//
//  Item.swift
//  AppTodoFinals
//
//  Created by Bee on 9/18/18.
//  Copyright © 2018 Bee. All rights reserved.
//

import Foundation
import  RealmSwift

class Item: Object {
 @objc dynamic var title : String = ""
  @objc dynamic var done : Bool = false
  @objc dynamic var dateCreated : Date?
    // relation 1...n
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

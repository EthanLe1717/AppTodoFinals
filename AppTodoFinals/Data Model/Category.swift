//
//  Category.swift
//  AppTodoFinals
//
//  Created by Bee on 9/18/18.
//  Copyright © 2018 Bee. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name : String = ""
    // relation 
    let items = List<Item>()
   
}

//
//  Item.swift
//  AppTodoFinals
//
//  Created by Bee on 9/17/18.
//  Copyright © 2018 Bee. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable  {
    var title: String = ""
    var done: Bool = false
}


//
//  DataRealm.swift
//  AppTodoFinals
//
//  Created by Bee on 9/18/18.
//  Copyright © 2018 Bee. All rights reserved.
//

import Foundation
import RealmSwift

class DataRealm: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}

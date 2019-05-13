//
//  Category.swift
//  Todoey
//
//  Created by Andres Garcia Vega on 13/05/2019.
//  Copyright © 2019 Andres Garcia Vega. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let todoItems = List<TodoDTO>()
}

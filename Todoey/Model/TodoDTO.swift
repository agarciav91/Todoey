//
//  TodoDTO.swift
//  Todoey
//
//  Created by Andres Garcia Vega on 13/05/2019.
//  Copyright © 2019 Andres Garcia Vega. All rights reserved.
//

import Foundation
import RealmSwift

class TodoDTO: Object {
    @objc dynamic var todoItem : String = ""
    @objc dynamic var isChecked : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todoItems")
}

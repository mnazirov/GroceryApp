//
//  Product.swift
//  GroceryApp
//
//  Created by Marat on 07.04.2021.
//

import RealmSwift

class Product: Object {
    @objc dynamic var name = ""
    @objc dynamic var descr = ""
    @objc dynamic var isComplete = false
    @objc dynamic var date = Date()
}

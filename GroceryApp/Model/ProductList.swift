//
//  ProductList.swift
//  GroceryApp
//
//  Created by Marat on 07.04.2021.
//

import RealmSwift

class ProductList: Object {
    @objc dynamic var name = ""
    @objc dynamic var count = Date()
    let products = List<Product>()
}

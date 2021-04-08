//
//  StorageManager.swift
//  GroceryApp
//
//  Created by Marat on 08.04.2021.
//

import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    func save(shopList: ProductList) {
        do {
            try realm.write {
                realm.add(shopList)
            }
        } catch let error {
            print("Error when saving data in Realm: \(error)")
        }
    }
    
    private init() {}
}
